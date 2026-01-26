import eslint from '@eslint/js';
import tsEslint from 'typescript-eslint';
import angularEslint from 'angular-eslint';
import prettierConfig from 'eslint-config-prettier';
import simpleImportSort from 'eslint-plugin-simple-import-sort';
import unusedImports from 'eslint-plugin-unused-imports';
import importPlugin from 'eslint-plugin-import';

export default tsEslint.config(
  // ==================================================
  // 🔹 TypeScript / Angular source files
  // ==================================================
  {
    files: ['**/*.ts'],
    ignores: ['.angular/**', '.nx/**', 'coverage/**', 'dist/**'],

    extends: [
      eslint.configs.recommended,
      ...tsEslint.configs.recommended,
      ...tsEslint.configs.stylistic,
      ...angularEslint.configs.tsRecommended,
      prettierConfig,
    ],

    processor: angularEslint.processInlineTemplates,

    plugins: {
      'simple-import-sort': simpleImportSort,
      'unused-imports': unusedImports,
      import: importPlugin,
    },

    rules: {
      // =========================
      // TypeScript
      // =========================
      '@typescript-eslint/no-explicit-any': 'warn',

      // =========================
      // Naming & visibility
      // =========================
      '@typescript-eslint/naming-convention': [
        'error',
        {
          selector: 'property',
          modifiers: ['private'],
          format: ['camelCase'],
          leadingUnderscore: 'require',
        },
        {
          selector: 'memberLike',
          modifiers: ['public'],
          format: ['camelCase'],
        },
      ],

      '@typescript-eslint/explicit-member-accessibility': [
        'error',
        { accessibility: 'explicit' },
      ],

      // =========================
      // Member ordering (Signals friendly)
      // =========================
      '@typescript-eslint/member-ordering': [
  'error',
  {
    default: [
      'signature',

      // 🔹 Static fields
      'public-static-field',
      'protected-static-field',
      'private-static-field',

      // 🔹 Instance fields (NO se separan por visibilidad)
      'instance-field',

      // 🔹 Constructor
      'constructor',

      // 🔹 Methods
      'public-instance-method',
      'protected-instance-method',
      'private-instance-method',
    ],
  },
],

      // =========================
      // Imports
      // =========================
      'simple-import-sort/imports': 'error',
      'simple-import-sort/exports': 'error',

      'import/no-duplicates': 'error',
      'import/newline-after-import': 'error',

      // =========================
      // Dead code
      // =========================
      'unused-imports/no-unused-imports': 'error',
    },
  },

  // ==================================================
  // 🔹 Angular templates
  // ==================================================
  {
    files: ['**/*.html'],
    extends: [
      ...angularEslint.configs.templateRecommended,
      ...angularEslint.configs.templateAccessibility,
    ],
    rules: {},
  },
);
