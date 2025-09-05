import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';
import angular from 'angular-eslint';
import eslintConfigPrettier from 'eslint-config-prettier';
import simpleImportSort from 'eslint-plugin-simple-import-sort';
import unusedImports from 'eslint-plugin-unused-imports';
import importPlugin from 'eslint-plugin-import';

export default tseslint.config(
  {
    ignores: ['.angular/**', '.nx/**', 'coverage/**', 'dist/**'],
    files: ['**/*.ts'],
    extends: [
      eslint.configs.recommended,       // Reglas recomendadas ESLint
      ...tseslint.configs.recommended,  // Reglas recomendadas TS
      ...tseslint.configs.stylistic,    // Estilo de código TS
      ...angular.configs.tsRecommended, // Reglas recomendadas Angular TS
      eslintConfigPrettier,             // Compatibilidad con Prettier
    ],
    processor: angular.processInlineTemplates,
    plugins: {
      'simple-import-sort': simpleImportSort, // Orden de imports
      'unused-imports': unusedImports,        // Detecta imports no usados
      'import': importPlugin,                  // Reglas adicionales de imports
    },
    rules: {
      // 🔹 Tipado estricto
      //'@typescript-eslint/no-explicit-any': 'error', 

      // 🔹 Nombres y accesibilidad
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

      // 🔹 Orden de miembros
      '@typescript-eslint/member-ordering': [
        'error',
        {
          default: [
            'private-field',
            'public-field',
            'constructor',
            'private-method',
            'public-method',
          ],
        },
      ],

      // 🔹 Angular OnPush
      '@angular-eslint/prefer-on-push-component-change-detection': 'error',

      // 🔹 Orden de imports
      'simple-import-sort/imports': 'error',
      'simple-import-sort/exports': 'error',

      // 🔹 Import plugin
      'import/no-duplicates': 'error',       // Evita duplicados
      'import/newline-after-import': 'error',// Línea en blanco tras imports

      // 🔹 Unused imports
      'unused-imports/no-unused-imports': 'error', 
    },
  },
  {
    files: ['**/*.html'],
    extends: [
      ...angular.configs.templateRecommended,     // Reglas Angular templates
      ...angular.configs.templateAccessibility,  // Reglas de accesibilidad
    ],
    rules: {
      // Aquí se pueden agregar reglas específicas de templates
    },
  },
);
