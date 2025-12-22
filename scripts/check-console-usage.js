#!/usr/bin/env node

/**
 * Vérifie l'utilisation de console.* dans le code source
 * Interdit console.log/warn/error/debug/info en dehors des tests et fichiers autorisés
 */

import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)
const ROOT = path.resolve(__dirname, '..')
const SRC = path.join(ROOT, 'src')

const IGNORE_PATTERNS = [
  /\.spec\./i,
  /\.test\./i,
  /__tests__\//,
  /\/tests\//,
  /src\/workers\//, // Workers can use console
  /\/coverage\//
]

const FILE_EXTS = new Set(['.ts', '.tsx', '.js', '.jsx', '.mjs', '.cjs'])

function walk(dir) {
  const entries = fs.readdirSync(dir, { withFileTypes: true })
  let files = []
  for (const entry of entries) {
    const res = path.join(dir, entry.name)
    if (entry.isDirectory()) {
      files = files.concat(walk(res))
    } else {
      files.push(res)
    }
  }
  return files
}

function isIgnored(filePath) {
  for (const rx of IGNORE_PATTERNS) {
    if (rx.test(filePath)) return true
  }
  return false
}

function main() {
  console.log('🔍 Checking for console.* usage in source files...\n')

  const files = walk(SRC).filter((f) => FILE_EXTS.has(path.extname(f)))
  const offenders = []

  const consoleRegex = /\bconsole\.(log|warn|error|debug|info)\s*\(/g

  for (const file of files) {
    const rel = path.relative(ROOT, file)
    if (isIgnored(rel)) continue

    let content = fs.readFileSync(file, 'utf-8')

    // Remove comments before searching for console.* to allow examples in doc blocks
    // Remove block comments
    content = content.replaceAll(/\/\*[\s\S]*?\*\//g, '')
    // Remove any leftover lines like '*   console.log(...)' which may remain after docblock pruning
    content = content.replaceAll(/^\s*\*\s*console\.[^\n]*$/gm, '')
    // Remove single-line comments
    content = content.replaceAll(/\/\/.*$/gm, '')

    if (consoleRegex.test(content)) {
      offenders.push(rel)
    }
  }

  if (offenders.length > 0) {
    console.error('❌ Found console.* usages in non-test files:\n')
    for (const f of offenders) console.error('  -', f)
    console.error(
      '\n💡 Consider removing these or adding an exception in scripts/check-console-usage.js'
    )
    process.exit(1)
  }

  console.log('✅ No console.* usages found in src (excluding tests/workers).')
}

main()
