// Colores ANSI para la consola
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  dim: '\x1b[2m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  magenta: '\x1b[35m',
  cyan: '\x1b[36m',
  white: '\x1b[37m',
};

type LogLevel = 'info' | 'warn' | 'error' | 'debug';

class Logger {
  private currentLevel: LogLevel = 'debug'; // Nivel actual (puedes hacerlo configurable)

  private levelPriority: Record<LogLevel, number> = {
    error: 0,
    warn: 1,
    info: 2,
    debug: 3,
  };

  private shouldLog(level: LogLevel) {
    return this.levelPriority[level] <= this.levelPriority[this.currentLevel];
  }

  info(message: string, ...args: unknown[]) {
    if (!this.shouldLog('info')) return;
    console.log(`${colors.green}[INFO]${colors.reset} ${message}`, ...args);
  }

  warn(message: string, ...args: unknown[]) {
    if (!this.shouldLog('warn')) return;
    console.warn(`${colors.yellow}[WARN]${colors.reset} ${message}`, ...args);
  }

  error(message: string, ...args: unknown[]) {
    if (!this.shouldLog('error')) return;
    console.error(`${colors.red}[ERROR]${colors.reset} ${message}`, ...args);
  }

  debug(message: string, ...args: unknown[]) {
    if (!this.shouldLog('debug')) return;
    console.debug(`${colors.cyan}[DEBUG]${colors.reset} ${message}`, ...args);
  }

  setLevel(level: LogLevel) {
    this.currentLevel = level;
  }
}

export const logger = new Logger();
