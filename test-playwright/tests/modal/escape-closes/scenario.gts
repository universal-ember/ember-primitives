import { on } from '@ember/modifier';

import { Modal } from 'ember-primitives';

<template>
  <Modal as |m|>
    <button type="button" id="open-modal" {{on "click" m.open}}>Open modal</button>
    <m.Dialog aria-label="Settings">
      <button type="button">Save</button>
    </m.Dialog>
  </Modal>
</template>
