# createAsyncService

This utility will create a service using a class definition similar to what is described in [RFC#502](https://github.com/emberjs/rfcs/pull/502) for explicit service injection -- no longer using strings. This allows module graphs to shake out services that aren't used until they are _needed_.

The difference with `createService` is that `createAsyncService` takes a _stable reference_ to a function that will eventually return a class definition. 

This can be useful for importing services that may themselves import many things, or large dependencies.


## Setup

```bash 
pnpm add ember-primitives
```

Introduced in [0.47.0](https://github.com/universal-ember/ember-primitives/releases/tag/v0.47.0-ember-primitives)


## Usage

```js
import { createAsyncService } from 'ember-primitives/service';

// This function is the key that all consumers should use to get the same instance
const getService = async () => {
  let module = await import('./service/from/somewhere');
  return module.MyState;
}

class Demo extends Component {
  state = createAsyncService(this, getService);
}
```

### With Arguments

```js
import { createAsyncService } from 'ember-primitives/service';

class MyState {
  constructor(/* .. */ ) { /* ... */ }
}

// in another file

// This function is the key that all consumers should use to get the same instance
const getService = async (/* args here */ ) => {
  let module = await import('./service/from/somewhere');
  return () => new module.MyState(/* args */ );
}

class Demo extends Component {
  state = createAsyncService(this, () => getService(/* ... */));
}
```


### Accessing Services and handling cleanup 

Like with [`link`][reactiveweb-link], use of services and `registerDestructor` is valid:
```js
import { service } from '@ember/service';
import { createAsyncService } from 'ember-primitives/service';

class MyState {
  @service router;

  constructor(/* .. */) { 
    registerDestructor(this, () => {
      // cleanup runs when Demo is torn down
    });  
  }
}

// in another file
class Demo extends Component {
  state = createAsyncService(this, getService);
}
```

However, note that the same restrictions as with `link` apply: services may not be accessed in the constructor.

And even that caveat can be undone if what you need is passed in to your service's constructor.

[reactiveweb-link]: https://reactive.nullvoxpopuli.com/functions/link.link.html 
