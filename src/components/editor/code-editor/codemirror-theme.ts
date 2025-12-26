import { HighlightStyle, syntaxHighlighting } from '@codemirror/language'
import { EditorView } from '@codemirror/view'
import { tags as t } from '@lezer/highlight'

/**
 * CPC Playground theme for CodeMirror
 * Matches the existing editor styling with green phosphor CRT aesthetic
 */

// Editor theme (layout, colors, etc.)
export const cpcTheme = EditorView.theme(
  {
    '&': {
      height: '100%',
      backgroundColor: 'transparent',
      fontSize: 'var(--font-size-sm)',
      fontFamily: 'var(--font-family)'
    },
    '.cm-content': {
      padding: '16px',
      caretColor: 'var(--color-primary)',
      fontFamily: 'var(--font-family)',
      lineHeight: '21px'
    },
    '.cm-cursor, .cm-dropCursor': {
      borderLeftColor: 'var(--color-primary)',
      borderLeftWidth: '2px'
    },
    '&.cm-focused .cm-cursor': {
      borderLeftColor: 'var(--color-primary)'
    },
    '.cm-selectionBackground, &.cm-focused .cm-selectionBackground, .cm-content ::selection':
      {
        backgroundColor: 'rgba(100, 200, 100, 0.3)'
      },
    '.cm-activeLine': {
      backgroundColor: 'rgba(100, 200, 100, 0.1)'
    },
    '.cm-gutters': {
      backgroundColor: 'rgba(0, 0, 0, 0.3)',
      color: 'var(--color-disabled-text)',
      border: 'none',
      minWidth: '52px'
    },
    '.cm-lineNumbers': {
      minWidth: '52px'
    },
    '.cm-lineNumbers .cm-gutterElement': {
      padding: '0 8px 0 8px',
      minWidth: '52px',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'flex-end'
    },
    '.cm-foldGutter': {
      minWidth: '16px'
    },
    '.cm-scroller': {
      overflow: 'auto',
      fontFamily: 'var(--font-family)',
      lineHeight: '21px'
    },
    '.cm-line': {
      padding: '0'
    },
    // Search panel styling
    '.cm-panels': {
      backgroundColor: 'rgba(42, 58, 42, 0.9)',
      color: 'var(--color-foreground)'
    },
    '.cm-panels.cm-panels-top': {
      borderBottom: '1px solid var(--color-border)'
    },
    '.cm-searchMatch': {
      backgroundColor: 'rgba(255, 200, 0, 0.3)',
      outline: '1px solid rgba(255, 200, 0, 0.5)'
    },
    '.cm-searchMatch.cm-searchMatch-selected': {
      backgroundColor: 'rgba(255, 200, 0, 0.5)'
    },
    // Tooltip styling
    '.cm-tooltip': {
      backgroundColor: 'var(--color-background)',
      border: '1px solid var(--color-border)',
      borderRadius: 'var(--radius-sm)'
    },
    '.cm-tooltip-autocomplete': {
      '& > ul > li[aria-selected]': {
        backgroundColor: 'rgba(100, 200, 100, 0.2)'
      }
    },
    // Error line styling
    '.cm-errorLine': {
      backgroundColor: 'rgba(255, 80, 80, 0.15)'
    },
    '.cm-errorGutter': {
      color: 'var(--color-error)',
      fontWeight: 'bold',
      backgroundColor: 'rgba(255, 80, 80, 0.3)'
    },
    '.cm-errorGutter::before': {
      content: '""',
      position: 'absolute',
      left: '0',
      top: '0',
      bottom: '0',
      width: '3px',
      backgroundColor: 'var(--color-error)'
    }
  },
  { dark: true }
)

// Syntax highlighting colors
export const cpcHighlightStyle = HighlightStyle.define([
  // Keywords (instructions, directives) - bright green
  { tag: t.keyword, color: '#50fa7b', fontWeight: 'bold' },

  // Registers - cyan
  { tag: t.variableName, color: '#8be9fd' },

  // Conditions (z, nz, c, nc, etc.) - orange
  { tag: t.atom, color: '#ffb86c' },

  // Numbers - purple
  { tag: t.number, color: '#bd93f9' },

  // Strings - yellow
  { tag: t.string, color: '#f1fa8c' },

  // Comments - gray/dimmed
  { tag: t.comment, color: '#6272a4', fontStyle: 'italic' },

  // Labels - pink
  { tag: t.labelName, color: '#ff79c6' },

  // Operators - white
  { tag: t.operator, color: '#f8f8f2' },

  // Brackets - white
  { tag: t.bracket, color: '#f8f8f2' },

  // Punctuation - dimmed
  { tag: t.punctuation, color: '#6272a4' },

  // Names (label references, macros) - light green
  { tag: t.name, color: '#98c379' }
])

/**
 * Complete CPC theme extension for CodeMirror
 * Combines editor theme with syntax highlighting
 */
export const cpcThemeExtension = [
  cpcTheme,
  syntaxHighlighting(cpcHighlightStyle)
]
