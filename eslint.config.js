import js from '@eslint/js'
import vue from 'eslint-plugin-vue'
import globals from 'globals'
import ts from 'typescript-eslint'

export default ts.config(
  { ignores: ['dist/**', 'node_modules/**'] },
  {
    files: ['src/**/*.{js,ts,vue}'],
    extends: [js.configs.recommended, ...ts.configs.recommended, ...vue.configs['flat/essential']],
    languageOptions: {
      globals: globals.browser,
      parserOptions: { parser: ts.parser },
    },
    rules: {
      'vue/multi-word-component-names': ['error', {
        ignores: ['Login', 'Register', 'Welcome', 'Wishlists'],
      }],
    },
  },
)
