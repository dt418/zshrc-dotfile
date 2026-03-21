module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'header-min-length': [2, 'always', 10],
    'header-max-length': [2, 'always', 72],
    'header-case': [2, 'always', ['lower-case']],
    'type-enum': [
      2,
      'always',
      [
        'feat',
        'fix',
        'docs',
        'style',
        'refactor',
        'test',
        'chore',
        'perf',
        'ci',
      ],
    ],
    'scope-enum': [
      2,
      'always',
      [
        'aliases',
        'functions',
        'plugins',
        'completion',
        'keybindings',
        'env',
        'install',
        'test',
        'docs',
        'hooks',
      ],
    ],
  },
};
