import { Menu } from 'ember-primitives';

<template>
  <Menu as |menu|>
    <menu.Trigger id="menu-trigger">Actions</menu.Trigger>
    <menu.Content id="menu-content" as |c|>
      <c.Item>One</c.Item>
      <c.Item>Two</c.Item>
    </menu.Content>
  </Menu>
</template>
