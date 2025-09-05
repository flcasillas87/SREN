import eslint from '@eslint/js';
import tsEslint from 'typescript-eslint';
import angularEslint from 'angular-eslint';
import prettierConfig from 'eslint-config-prettier';
import simpleImportSort from 'eslint-plugin-simple-import-sort';
import unusedImports from 'eslint-plugin-unused-imports';
import importPlugin from 'eslint-plugin-import';

/**
 * Configuración ESLint para Angular 20 + TypeScript
 * - Incluye soporte Prettier
 * - Orden de imports
 * - Reglas de estilo TS
 * - Reglas Angular para templates y accesibilidad
 */
export default tsEslint.config(
  {
    // Archivos TS a validar
    files: ['**/*.ts'],

    // Archivos/carpetas a ignorar
    ignores: ['.angular/**', '.nx/**', 'coverage/**', 'dist/**'],

    // Configs base
    extends: [
      eslint.configs.recommended, // Reglas ESLint base
      ...tsEslint.configs.recommended, // Reglas TypeScript recomendadas
      ...tsEslint.configs.stylistic, // Estilo TypeScript
      ...angularEslint.configs.tsRecommended, // Angular TS recomendado
      prettierConfig, // Compatibilidad Prettier
    ],

    // Procesador para templates inline en Angular
    processor: angularEslint.processInlineTemplates,

    // Plugins adicionales
    plugins: {
      'simple-import-sort': simpleImportSort,
      'unused-imports': unusedImports,
      import: importPlugin,
    },

    // Reglas específicas
    rules: {
      // Tipado estricto (descomentar si quieres prohibir any)
      // '@typescript-eslint/no-explicit-any': 'error',

      // Nombres y accesibilidad
      '@typescript-eslint/naming-convention': [
        'error',
        {
          selector: 'property',
          modifiers: ['private'],
          format: ['camelCase'],
          leadingUnderscore: 'require', // Privadas con _
        },
        {
          selector: 'memberLike',
          modifiers: ['public'],
          format: ['camelCase'], // Públicas camelCase
        },
      ],
      '@typescript-eslint/explicit-member-accessibility': [
        'error',
        { accessibility: 'explicit' }, // Todos los miembros deben declarar public/private
      ],

      // Orden de miembros en clases
      '@typescript-eslint/member-ordering': [
        'error',
        {
          default: ['private-field', 'public-field', 'constructor', 'private-method', 'public-method'],
        },
      ],

      // Angular OnPush
      '@angular-eslint/prefer-on-push-component-change-detection': 'error',

      // Orden de imports
      'simple-import-sort/imports': 'error',
      'simple-import-sort/exports': 'error',

      // Import plugin
      'import/no-duplicates': 'error',
      'import/newline-after-import': 'error',

      // Unused imports
      'unused-imports/no-unused-imports': 'error',
    },
  },

  // Configuración para HTML / templates Angular
  {
    files: ['**/*.html'],
    extends: [
      ...angularEslint.configs.templateRecommended, // Reglas templates Angular
      ...angularEslint.configs.templateAccessibility, // Accesibilidad
    ],
    rules: {
      // Reglas específicas de templates opcionales
    },
  },
);
