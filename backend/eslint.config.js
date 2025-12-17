// eslint.config.js
import js from '@eslint/js';
import tseslint from 'typescript-eslint';
import globals from 'globals';
import prettier from 'eslint-config-prettier';
import path from 'path';
import url from 'url';

const __filename = url.fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export default [
  {
    ignores: ['dist/', 'node_modules/'],
  },

  // Configuración recomendada de JS
  js.configs.recommended,

  // Configuración recomendada de TS para Flat Config
  ...tseslint.configs.recommended,

  // Prettier (versión Flat Config)
  prettier,

  // Config personalizada para TS en src
  {
    files: ['src/**/*.ts'],
    languageOptions: {
      globals: {
        ...globals.node,
      },
      parserOptions: {
        project: './tsconfig.json',
        tsconfigRootDir: __dirname,
      },
    },
    rules: {
      'no-var': 'error',
      '@typescript-eslint/no-explicit-any': 'warn',
    },
  },
];
