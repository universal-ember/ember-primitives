import { Rating } from 'ember-primitives';

<template>
  <Rating @value={{2}} @readonly={{true}}>
    <:label>Readonly rating</:label>
  </Rating>
</template>
