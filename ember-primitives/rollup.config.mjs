import typescript from 'rollup-plugin-ts';
import copy from 'rollup-plugin-copy';
import { Addon } from '@embroider/addon-dev/rollup';
import { glimmerTemplateTag } from 'rollup-plugin-glimmer-template-tag';

const addon = new Addon({
  srcDir: 'src',
  destDir: 'dist',
});

export default {
  output: addon.output(),

  plugins: [
    addon.publicEntrypoints(['**/*.js']),
    addon.appReexports(['components/**/*.js', 'helpers/**/*.js']),
    addon.dependencies(),
    typescript({
      transpiler: 'babel',
      browserslist: ['last 1 firefox versions'],
      transpileOnly: true,
    }),
    addon.hbs(),
    glimmerTemplateTag(),
    addon.keepAssets(['**/*.css']),
    addon.clean(),
    copy({
      targets: [
        { src: '../README.md', dest: '.' },
        { src: '../LICENSE.md', dest: '.' },
      ],
    }),
  ],
};
