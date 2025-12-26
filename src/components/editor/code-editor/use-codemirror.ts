import { autocompletion, closeBrackets } from '@codemirror/autocomplete'
import {
  defaultKeymap,
  history,
  historyKeymap,
  indentWithTab
} from '@codemirror/commands'
import { bracketMatching, indentOnInput } from '@codemirror/language'
import { linter, lintGutter } from '@codemirror/lint'
import { highlightSelectionMatches, searchKeymap } from '@codemirror/search'
import {
  Compartment,
  EditorState,
  type Extension,
  RangeSetBuilder
} from '@codemirror/state'
// Custom gutter marker for error lines
import {
  Decoration,
  drawSelection,
  dropCursor,
  EditorView,
  highlightActiveLine,
  highlightActiveLineGutter,
  keymap,
  lineNumbers,
  ViewPlugin,
  type ViewUpdate
} from '@codemirror/view'
import { vsCodeDark } from '@fsegurai/codemirror-theme-vscode-dark'
import { vsCodeLight } from '@fsegurai/codemirror-theme-vscode-light'
import { type RefObject, useEffect, useRef } from 'react'
import { z80 } from './z80-language'

type ConsoleMessage = Readonly<{
  id: string
  type: 'info' | 'error' | 'success' | 'warning'
  text: string
  timestamp: Date
  line?: number
}>

// Decoration for error lines
const errorLineDecoration = Decoration.mark({
  class: 'cm-error-line',
  block: true
})

// Function to create error line plugin
function createErrorLinePlugin(consoleMessages: readonly ConsoleMessage[]) {
  return ViewPlugin.fromClass(
    class {
      decorations: any

      constructor(view: EditorView) {
        this.decorations = this.computeDecorations(view, consoleMessages)
      }

      update(update: ViewUpdate) {
        if (update.docChanged || update.viewportChanged) {
          this.decorations = this.computeDecorations(
            update.view,
            consoleMessages
          )
        }
      }

      computeDecorations(
        view: EditorView,
        messages: readonly ConsoleMessage[]
      ) {
        const builder = new RangeSetBuilder<Decoration>()

        for (const message of messages) {
          // Check if this is an error message (either by type or by content)
          const isError =
            message.type === 'error' ||
            (message.text?.includes('[/input.asm:') &&
              message.line !== undefined)
          if (isError && message.line !== undefined) {
            const line = view.state.doc.line(message.line)
            builder.add(line.from, line.to, errorLineDecoration)
          }
        }

        const result = builder.finish()
        return result
      }
    },
    {
      decorations: (value) => value.decorations
    }
  )
}

// Create a transparent version of VS Code dark theme
const transparentVsCodeDark = [
  vsCodeDark,
  EditorView.theme({
    '&': {
      backgroundColor: 'transparent !important'
    },
    '.cm-scroller': {
      backgroundColor: 'transparent !important'
    },
    '.cm-content': {
      backgroundColor: 'transparent !important'
    },
    '.cm-line': {
      backgroundColor: 'transparent !important'
    }
  })
]

// Linter function that provides diagnostics from console messages
function consoleLinter(consoleMessages: readonly ConsoleMessage[]) {
  return (view: EditorView) => {
    const diagnostics: any[] = []
    for (const message of consoleMessages) {
      if (message.line !== undefined) {
        // Create diagnostics for all message types
        let severity: 'info' | 'warning' | 'error'
        if (message.type === 'error') {
          severity = 'error'
        } else if (message.type === 'warning') {
          severity = 'warning'
        } else {
          severity = 'info'
        }

        // Check if this is an error message from RASM (contains file reference)
        if (message.text?.includes('[/input.asm:')) {
          severity = 'error'
        }

        const line = view.state.doc.line(message.line)
        diagnostics.push({
          from: line.from,
          to: line.to,
          severity,
          message: message.text
        })
      }
    }
    console.log('Diagnostics created:', diagnostics)
    return diagnostics
  }
}

type UseCodeMirrorProps = {
  initialCode: string
  readOnly?: boolean
  consoleMessages: readonly ConsoleMessage[]
  onInput: (value: string) => void
  containerRef: RefObject<HTMLDivElement | null>
  onViewCreated?: (view: EditorView) => void
  theme?: 'vscode-light' | 'vscode-dark'
}

export function useCodeMirror({
  initialCode,
  readOnly = false,
  consoleMessages,
  onInput,
  containerRef,
  onViewCreated,
  theme = 'vscode-dark'
}: UseCodeMirrorProps) {
  const viewRef = useRef<EditorView | null>(null)
  const linterCompartment = useRef(new Compartment())
  const errorLineCompartment = useRef(new Compartment())
  const onInputRef = useRef(onInput)
  const initialCodeRef = useRef(initialCode)

  // Update initialCode ref only if it's different (for external changes)
  useEffect(() => {
    if (initialCodeRef.current !== initialCode) {
      initialCodeRef.current = initialCode
    }
  }, [initialCode])

  // Keep callback ref updated
  useEffect(() => {
    onInputRef.current = onInput
  }, [onInput])

  // Create editor on mount and when key changes
  useEffect(() => {
    const parent = containerRef.current
    if (!parent) return

    // Clean up previous editor
    if (viewRef.current) {
      viewRef.current.destroy()
      viewRef.current = null
    }

    const themeExtension =
      theme === 'vscode-dark' ? transparentVsCodeDark : vsCodeLight

    const extensions: Extension[] = [
      history(),
      drawSelection(),
      dropCursor(),
      indentOnInput(),
      bracketMatching(),
      closeBrackets(),
      highlightActiveLine(),
      highlightActiveLineGutter(),
      highlightSelectionMatches(),
      lineNumbers(),
      lintGutter(),
      linterCompartment.current.of(linter(consoleLinter(consoleMessages))),
      errorLineCompartment.current.of(createErrorLinePlugin(consoleMessages)),
      z80(),
      themeExtension,
      keymap.of([
        ...defaultKeymap,
        ...historyKeymap,
        ...searchKeymap,
        indentWithTab
      ]),
      autocompletion(),
      EditorView.updateListener.of((update) => {
        if (update.docChanged) {
          onInputRef.current(update.state.doc.toString())
        }
      }),
      EditorState.readOnly.of(readOnly)
    ]

    const state = EditorState.create({
      doc: initialCodeRef.current,
      extensions
    })

    const view = new EditorView({
      state,
      parent
    })

    viewRef.current = view

    onViewCreated?.(view)

    return () => {
      view.destroy()
      viewRef.current = null
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [readOnly, containerRef, onViewCreated, theme, consoleMessages])

  // Update editor content when initialCode changes externally (e.g., after save)
  useEffect(() => {
    if (viewRef.current && initialCodeRef.current !== initialCode) {
      initialCodeRef.current = initialCode
      viewRef.current.dispatch({
        changes: {
          from: 0,
          to: viewRef.current.state.doc.length,
          insert: initialCode
        }
      })
    }
  }, [initialCode])

  // Update linter when console messages change
  useEffect(() => {
    if (viewRef.current) {
      // Reconfigure linter
      viewRef.current.dispatch({
        effects: linterCompartment.current.reconfigure(
          linter(consoleLinter(consoleMessages))
        )
      })
      // Reconfigure error line plugin
      viewRef.current.dispatch({
        effects: errorLineCompartment.current.reconfigure(
          createErrorLinePlugin(consoleMessages)
        )
      })
    }
  }, [consoleMessages])

  return viewRef
}

// Hook to expose editor methods
export function useCodeMirrorMethods(viewRef: RefObject<EditorView | null>) {
  const goToLine = (lineNum: number) => {
    const view = viewRef.current
    if (!view) return

    const doc = view.state.doc
    if (lineNum < 1 || lineNum > doc.lines) return

    const line = doc.line(lineNum)
    view.dispatch({
      selection: { anchor: line.from },
      scrollIntoView: true
    })
    view.focus()
  }

  const focus = () => {
    viewRef.current?.focus()
  }

  const getValue = (): string => {
    return viewRef.current?.state.doc.toString() ?? ''
  }

  const setValue = (value: string) => {
    const view = viewRef.current
    if (!view) return

    view.dispatch({
      changes: {
        from: 0,
        to: view.state.doc.length,
        insert: value
      }
    })
  }

  return { goToLine, focus, getValue, setValue }
}
