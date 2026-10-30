import { on } from '@ember/modifier';

import { Menu, Modal } from 'ember-primitives';

<template>
  <Modal as |m|>
    <button type="button" id="open-modal" {{on "click" m.open}}>Open modal</button>
    <m.Dialog aria-label="Settings">
      <Menu as |menu|>
        <menu.Trigger id="menu-trigger">Actions</menu.Trigger>
        <menu.Content id="menu-content" as |c|>
          <c.Item>One</c.Item>
          <c.Item>Two</c.Item>
        </menu.Content>
      </Menu>
    </m.Dialog>
  </Modal>
</template>
