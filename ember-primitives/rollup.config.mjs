import copy from 'rollup-plugin-copy';
import { babel } from '@rollup/plugin-babel';
import { Addon } from '@embroider/addon-dev/rollup';
import { nodeResolve } from '@rollup/plugin-node-resolve';
// import { glimmerTemplateTag } from 'rollup-plugin-glimmer-template-tag';

const addon = new Addon({
  srcDir: 'src',
  destDir: 'dist',
});

const extensions = ['.js', '.ts', '.gts', '.gjs'];

export default {
  output: addon.output(),
  plugins: [
    addon.publicEntrypoints(['**/*.js']),
    addon.appReexports(['components/*.js', 'helpers/**/*.js']),
    addon.dependencies(),
    // glimmerTemplateTag(),
    // Node-resolve is needed because we can't have gts extensions
    // in imports and have type-declarations generated correctly
    // (unless there is more config to have somewhere?)
    // nodeResolve({ extensions }),
    babel({ extensions, babelHelpers: 'inline' }),
    addon.hbs(),
    addon.gjs(),
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
