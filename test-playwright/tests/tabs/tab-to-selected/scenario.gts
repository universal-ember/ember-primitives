import { Tabs } from 'ember-primitives/components/tabs';

<template>
  <button type="button" id="before-tabs">Before tabs</button>
  <Tabs @label="Fruit" @activeTab="banana" as |Tab|>
    <Tab @value="apple" @label="Apple" @content="Red" />
    <Tab @value="banana" @label="Banana" @content="Yellow" />
  </Tabs>
</template>
