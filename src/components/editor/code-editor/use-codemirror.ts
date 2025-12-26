import { autocompletion, closeBrackets } from '@codemirror/autocomplete'
import {
  defaultKeymap,
  history,
  historyKeymap,
  indentWithTab
} from '@codemirror/commands'
import { bracketMatching, indentOnInput } from '@codemirror/language'
import { lintGutter } from '@codemirror/lint'
import { highlightSelectionMatches, searchKeymap } from '@codemirror/search'
import {
  EditorState,
  type Extension,
  RangeSetBuilder,
  StateEffect,
  StateField
} from '@codemirror/state'
// Custom gutter marker for error lines
import {
  Decoration,
  type DecorationSet,
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
import { type RefObject, useEffect, useRef } from 'react'
import { cpcThemeExtension } from './codemirror-theme'
import { z80 } from './z80-language'

// Effect to update error lines
const setErrorLines = StateEffect.define<readonly number[]>()

// State field to track error lines
const errorLinesField = StateField.define<readonly number[]>({
  create() {
    return []
  },
  update(value, tr) {
    for (const effect of tr.effects) {
      if (effect.is(setErrorLines)) {
        return effect.value
      }
    }
    return value
  }
})

// Decoration for error lines
const errorLineDecoration = Decoration.line({ class: 'cm-errorLine' })

// Plugin to apply error line decorations
const errorLinePlugin = ViewPlugin.fromClass(
  class {
    decorations: DecorationSet

    constructor(view: EditorView) {
      this.decorations = this.buildDecorations(view)
    }

    update(update: ViewUpdate) {
      if (
        update.docChanged ||
        update.transactions.some((tr) =>
          tr.effects.some((e) => e.is(setErrorLines))
        )
      ) {
        this.decorations = this.buildDecorations(update.view)
      }
    }

    buildDecorations(view: EditorView): DecorationSet {
      const builder = new RangeSetBuilder<Decoration>()
      const errorLines = view.state.field(errorLinesField)
      const doc = view.state.doc

      for (const lineNum of errorLines) {
        if (lineNum >= 1 && lineNum <= doc.lines) {
          const line = doc.line(lineNum)
          builder.add(line.from, line.from, errorLineDecoration)
        }
      }

      return builder.finish()
    }
  },
  {
    decorations: (v) => v.decorations
  }
)

type UseCodeMirrorProps = {
  initialCode: string
  readOnly?: boolean
  errorLines: readonly number[]
  onInput: (value: string) => void
  containerRef: RefObject<HTMLDivElement | null>
  onViewCreated?: (view: EditorView) => void
}

export function useCodeMirror({
  initialCode,
  readOnly = false,
  errorLines,
  onInput,
  containerRef,
  onViewCreated
}: UseCodeMirrorProps) {
  const viewRef = useRef<EditorView | null>(null)
  const onInputRef = useRef(onInput)

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
      errorLinesField,
      errorLinePlugin,
      z80(),
      ...cpcThemeExtension,
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
      doc: initialCode,
      extensions
    })

    const view = new EditorView({
      state,
      parent
    })

    viewRef.current = view

    if (errorLines.length > 0) {
      view.dispatch({
        effects: setErrorLines.of(errorLines)
      })
    }

    onViewCreated?.(view)

    return () => {
      view.destroy()
      viewRef.current = null
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [readOnly, initialCode, errorLines, containerRef, onViewCreated])

  // Update error lines when they change
  useEffect(() => {
    if (viewRef.current) {
      viewRef.current.dispatch({
        effects: setErrorLines.of(errorLines)
      })
    }
  }, [errorLines])

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
