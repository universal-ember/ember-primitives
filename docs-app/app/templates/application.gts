import pageTitle from 'ember-page-title/helpers/page-title';

import { Shell } from '@universal-ember/docs-support';

<template>
  <Shell>
    {{pageTitle "ember-primitives"}}

    {{outlet}}
  </Shell>
</template>
