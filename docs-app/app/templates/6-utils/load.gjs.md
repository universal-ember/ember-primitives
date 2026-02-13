# Load

A utility for creating a component that handles the loading of a promise or function.
Can be use for manual, import-based, bundle splittiing (or any other async activity.


This is a very tiny wrapper around reactiveweb's [`getPromiseState`](https://reactive.nullvoxpopuli.com/functions/get-promise-state.getPromiseState.html)

## Install

```hbs live
<SetupInstructions @src="load.gts" />
```


## Usage

```gjs
import { load } from 'ember-primitives/load';

const Loader = load(() => import('./routes/sub-route.gts'));

<template>
   <Loader>
     <:loading> ... loading ... </:loading>
     <:error as |error|> ... error! {{error.reason}} </:error>
     <:success as |component|> <component /> </:success>
   </Loader>
</template>
```


