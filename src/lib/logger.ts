/**
 * Centralized logging service
 *
 * Provides structured logging with levels and context.
 * In development, logs to console with formatting.
 * In production, could be extended to send to external services.
 */

type LogLevel = 'debug' | 'info' | 'warn' | 'error'

interface LogEntry {
  level: LogLevel
  message: string
  context?: unknown
  timestamp: Date
  source?: string
}

type LogHandler = (entry: LogEntry) => void

const LOG_LEVELS: Record<LogLevel, number> = {
  debug: 0,
  info: 1,
  warn: 2,
  error: 3
}

class Logger {
  private minLevel: LogLevel = import.meta.env.DEV ? 'debug' : 'info'
  private handlers: LogHandler[] = []
  private readonly source?: string

  constructor(source?: string) {
    this.source = source
    // Default console handler
    this.handlers.push(this.consoleHandler.bind(this))
  }

  private shouldLog(level: LogLevel): boolean {
    return LOG_LEVELS[level] >= LOG_LEVELS[this.minLevel]
  }

  private consoleHandler(entry: LogEntry): void {
    const { level, message, context, source } = entry
    const prefix = source ? `[${source}]` : ''
    const formattedMessage = prefix ? `${prefix} ${message}` : message

    switch (level) {
      case 'debug':
        // eslint-disable-next-line no-console
        console.debug(formattedMessage, context ?? '')
        break
      case 'info':
        // eslint-disable-next-line no-console
        console.info(formattedMessage, context ?? '')
        break
      case 'warn':
        // eslint-disable-next-line no-console
        console.warn(formattedMessage, context ?? '')
        break
      case 'error':
        // eslint-disable-next-line no-console
        console.error(formattedMessage, context ?? '')
        break
    }
  }

  private log(level: LogLevel, message: string, context?: unknown): void {
    if (!this.shouldLog(level)) return

    const entry: LogEntry = {
      level,
      message,
      context,
      timestamp: new Date(),
      source: this.source
    }

    for (const handler of this.handlers) {
      try {
        handler(entry)
      } catch {
        // Prevent handler errors from breaking logging
      }
    }
  }

  debug(message: string, context?: unknown): void {
    this.log('debug', message, context)
  }

  info(message: string, context?: unknown): void {
    this.log('info', message, context)
  }

  warn(message: string, context?: unknown): void {
    this.log('warn', message, context)
  }

  error(message: string, context?: unknown): void {
    this.log('error', message, context)
  }

  /**
   * Create a child logger with a specific source
   */
  child(source: string): Logger {
    const childLogger = new Logger(
      this.source ? `${this.source}:${source}` : source
    )
    childLogger.handlers = this.handlers
    childLogger.minLevel = this.minLevel
    return childLogger
  }

  /**
   * Add a custom log handler (e.g., for external services)
   */
  addHandler(handler: LogHandler): void {
    this.handlers.push(handler)
  }

  /**
   * Set minimum log level
   */
  setLevel(level: LogLevel): void {
    this.minLevel = level
  }
}

// Singleton instance
export const logger = new Logger()

// Factory for creating scoped loggers
export function createLogger(source: string): Logger {
  return logger.child(source)
}

export type { LogLevel, LogEntry, LogHandler }
