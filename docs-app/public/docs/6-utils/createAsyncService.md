# createAsyncService

This utility will create a service using a class definition similar to what is described in [RFC#502](https://github.com/emberjs/rfcs/pull/502) for explicit service injection -- no longer using strings. This allows module graphs to shake out services that aren't used until they are _needed_.

The difference with `createService` is that `createAsyncService` takes a _stable reference_ to a function that will eventually return a class definition. 

This can be useful for importing services that may themselves import many things, or large dependencies.

[gh-polaris-service]: https://github.com/chancancode/ember-polaris-service

<Callout>

  `createAsyncService` is not meant to be a replacement for `@service`, but a specific tool for asynchronously loading services when the hosting class has to be synchronously known.

  Another approach to dynamically loading services would be to dynamically load all components that use the serivce, such as via the [`load`](/6-utils/load.md) utility, and calling the service with etiher [`createService`](/6-utils/createService.md) or an [ember-polaris-service][gh-polaris-service].

  So `createAsyncService` shifts the resoponsibility of where the async state is being handled, but it should be handled (error, loading states), in either situation.



</Callout>


## Install

```hbs live
<SetupInstructions @src="service.ts" />
```


Introduced in [0.47.0](https://github.com/universal-ember/ember-primitives/releases/tag/v0.47.0-ember-primitives)


## Usage

`createAsyncService` doesn't expose the service _directly_, but instead it is wrapped in a reactive Promise State (in particular, the state returend by [getPromiseState](https://reactive.nullvoxpopuli.com/functions/get-promise-state.getPromiseState.html)).

When using async services, you have to be concerned with loading and error states, like this:

```gjs
import { createAsyncService } from 'ember-primitives/service';

class Demo extends Component {
  state = createAsyncService(this, /* ... */)

  <template>
    {{#if this.state.isLoading}}
    ... pending ...
    {{else if this.state.error}}
      oh no!
      {{this.state.error}}
    {{else if this.state.resolved}}

      Here is where you can access the full service
      And you'll have the same shared instance for the whole application -- a singleton.
      {{this.state.resolve.foo}}
    {{/if}}
  </template>
}


```

### In a component

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


## Testing

Testing with `createAsyncService` is a little different from  the `@service` from ember. In particular, `createAsyncService` takes the approach that the whole implementation is a black box, hidden, or private from the caller.
You can still unit test the service as you would any other class. But for consmers, mocking is not supported. If there is a state that needs to be tested, the component(s) owning the service should manipulate the service in to getting in to that state.

If the service is performing operations with the network, you'll want to mock the network -- with tools such as [MSW](https://mswjs.io/), or [WarpDrive](https://warp-drive.io/)'s holodeck.


