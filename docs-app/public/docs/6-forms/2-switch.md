# Switch

Here is an example of how to integrate `<Switch />` with `<HeadlessForm />`, using Bootstrap for styling.

[docs-switch]: /3-components/switch

```gjs live preview 
import { HeadlessForm } from 'ember-headless-form';
import { Switch } from 'ember-primitives';
import { cell } from 'ember-resources';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';

const data = cell({ stayLoggedIn: false });

function handleSubmit(submittedData) {
  data.current = { ...submittedData }; 
}

function handleChange(set, event) {
  set(event.target.checked);
}

<template>
  <HeadlessForm @data={{data.current}} @onSubmit={{handleSubmit}} as |form|>
    <form.Field @name='stayLoggedIn' as |field|>
      <Switch class="form-check form-switch" as |s|>
        <s.Control 
          class="form-check-input" 
          id={{field.id}}
          name="stayLoggedIn"
          checked={{field.value}}
          {{on 'change' (fn handleChange field.setValue)}} 
        />
        <field.Label class="form-check-label">
          Stay Logged In
        </field.Label>
      </Switch>
    </form.Field>

    <button type='submit' class="btn btn-primary">Submit</button>
  </HeadlessForm>
  
  <br />Submitted form data:
  <pre>{{JSON.stringify data.current null 3}}</pre>


  {{!-- Using Bootstrap styles --}}
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
</template>
```
