#!/usr/bin/env node

/**
 * Script de vérification TypeScript avancée
 * Utilise tsc -b comme le build pour une vérification cohérente
 */

import { execSync } from 'node:child_process'

console.log('🔍 Running TypeScript checks...')
console.log('🔍 Running comprehensive TypeScript check...')

let hasErrors = false

// Utiliser tsc -b comme le build pour une cohérence totale
console.log('\n📋 Running tsc -b (same as build)...')

try {
  execSync('npx tsc -b', {
    encoding: 'utf8',
    stdio: 'pipe'
  })
  console.log('✅ tsc -b - No TypeScript errors')
} catch (error) {
  console.error('❌ TypeScript errors found:')
  console.error(error.stdout || error.stderr || error.message)
  hasErrors = true
}

// Vérification supplémentaire avec diagnostics
console.log('\n🔬 Running diagnostic checks...')

try {
  // Vérifier les imports non utilisés et autres problèmes
  execSync('npx tsc --noEmit --noUnusedLocals --noUnusedParameters', {
    stdio: 'pipe',
    encoding: 'utf8'
  })
  console.log('✅ No unused imports or parameters')
} catch (error) {
  console.warn('⚠️  Found unused imports/parameters:')
  console.warn(error.stdout)
  // Ne pas considérer cela comme une erreur bloquante
}

if (hasErrors) {
  console.error(
    '\n❌ TypeScript errors found! Please fix them before committing.'
  )
  process.exit(1)
} else {
  console.log('\n✅ All TypeScript checks passed!')
  process.exit(0)
}
