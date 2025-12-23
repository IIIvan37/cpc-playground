#!/usr/bin/env node

/**
 * Vérifie les exports des barrel files (index.ts)
 * S'assure que tous les exports référencent des symboles existants
 */

import { readdirSync, readFileSync, statSync } from 'node:fs'
import { join, relative } from 'node:path'

const ROOT = process.cwd()
const SRC = join(ROOT, 'src')

function findIndexFiles(dir, files = []) {
  const items = readdirSync(dir)
  for (const item of items) {
    const fullPath = join(dir, item)
    const stat = statSync(fullPath)
    if (
      stat.isDirectory() &&
      !item.startsWith('.') &&
      item !== 'node_modules' &&
      item !== 'dist'
    ) {
      findIndexFiles(fullPath, files)
    } else if (stat.isFile() && item === 'index.ts') {
      files.push(fullPath)
    }
  }
  return files
}

function extractExports(content) {
  const exports = []

  // Match: export { X, Y } from './file'
  // Also matches: export { type X, Y } from './file'
  const reExportRegex = /export\s*\{([^}]+)\}\s*from\s*['"]([^'"]+)['"]/g
  for (const match of content.matchAll(reExportRegex)) {
    const symbols = match[1].split(',').map((s) => {
      // Remove 'type ' prefix if present
      let symbol = s.trim()
      if (symbol.startsWith('type ')) {
        symbol = symbol.slice(5)
      }
      // Handle 'as' aliasing: take the original name
      return symbol.split(' as ')[0].trim()
    })
    const source = match[2]
    for (const symbol of symbols) {
      if (symbol) {
        exports.push({ symbol, source })
      }
    }
  }

  return exports
}

function checkIndexFile(indexPath) {
  const content = readFileSync(indexPath, 'utf8')
  const exports = extractExports(content)
  const errors = []

  for (const { symbol, source } of exports) {
    // Résoudre le chemin du fichier source
    const dir = join(indexPath, '..')
    let sourcePath = join(dir, source)
    if (!sourcePath.endsWith('.ts') && !sourcePath.endsWith('.tsx')) {
      sourcePath += '.ts'
    }

    try {
      const sourceContent = readFileSync(sourcePath, 'utf8')

      // Vérifier si le symbole est exporté dans le fichier source
      const exportPatterns = [
        new RegExp(
          String.raw`export\s+(const|let|var|function|class|type|interface|enum)\s+${symbol}\b`
        ),
        new RegExp(String.raw`export\s*\{[^}]*\b${symbol}\b[^}]*\}`),
        new RegExp(String.raw`export\s+default\s+${symbol}\b`)
      ]

      const isExported = exportPatterns.some((pattern) =>
        pattern.test(sourceContent)
      )

      if (!isExported) {
        errors.push({
          indexPath: relative(ROOT, indexPath),
          symbol,
          source
        })
      }
    } catch {
      // Fichier source non trouvé, ignorer (peut être un module externe)
    }
  }

  return errors
}

function main() {
  console.log('🔍 Checking barrel file exports...\n')

  const indexFiles = findIndexFiles(SRC)
  let allErrors = []

  for (const indexFile of indexFiles) {
    const errors = checkIndexFile(indexFile)
    allErrors = allErrors.concat(errors)
  }

  if (allErrors.length > 0) {
    console.error('❌ Found missing exports in barrel files:\n')
    for (const error of allErrors) {
      console.error(`  ${error.indexPath}:`)
      console.error(
        `    Symbol "${error.symbol}" not found in "${error.source}"`
      )
    }
    console.error(
      '\n💡 These exports reference symbols that do not exist in the source files.'
    )
    console.error('   Please remove or fix these exports.\n')
    process.exit(1)
  }

  console.log(`✅ All ${indexFiles.length} barrel files have valid exports!`)
  process.exit(0)
}

main()
