# Accordion

An accordion component is an element that organizes content into collapsible sections, enabling users to expand or collapse them for efficient information presentation and navigation.

<Callout>

Before reaching for this component, consider if the [native `<details>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/details) is sufficient for your use case.


<details><summary>example of <code>details</code></summary>

Like with the component, `<details>` and `<summary>` can be styled with CSS.

```gjs live preview
// No imports needed!
// If you need only one open a time, use the "name" attribute
// https://developer.mozilla.org/en-US/docs/Web/HTML/Element/details#name

<template>
  <div class="native-accordion">
    <details name="native-demo" open>
      <summary>What is Ember?</summary>
      <p>
        Ember.js is a productive, battle-tested JavaScript framework for building modern web
        applications.
      </p>
    </details>

    <details name="native-demo">
      <summary>When do I need Accordion?</summary>
      <p>
        Use the Accordion component when you need controlled state, keyboard patterns beyond
        native details, or design-system composition.
      </p>
    </details>

    <details name="native-demo">
      <summary>Can I style details?</summary>
      <p>Yes — native details and summary can be styled with CSS just like any other element.</p>
    </details>
  </div>

  <style>
    .native-accordion {
      display: grid;
      gap: 0.5rem;
      max-width: 28rem;
    }

    .native-accordion details {
      border: 1px solid var(--doc-border);
      border-radius: 0.5rem;
      background: var(--doc-bg);
      overflow: hidden;
    }

    .native-accordion summary {
      cursor: pointer;
      list-style: none;
      padding: 0.7rem 0.9rem;
      font-family: var(--font-sans);
      font-size: 0.875rem;
      font-weight: 500;
      color: var(--doc-text-1);
    }

    .native-accordion summary::-webkit-details-marker {
      display: none;
    }

    .native-accordion details[open] summary {
      border-bottom: 1px solid var(--doc-border);
      background: var(--doc-bg-soft);
    }

    .native-accordion p {
      margin: 0;
      padding: 0.8rem 0.9rem 1rem;
      font-size: 0.875rem;
      line-height: 1.55;
      color: var(--doc-text-2);
    }
  </style>
</template>
```

</details>

</Callout>

<div class="featured-demo">

```gjs live preview
import { Accordion } from 'ember-primitives';

<template>
  <Accordion class="faq" @type="single" as |A|>
    <A.Item class="item" @value="ember" as |I|>
      <I.Header as |H|>
        <H.Trigger class="trigger">What is Ember?</H.Trigger>
      </I.Header>
      <I.Content class="content">
        Ember.js is a productive, battle-tested JavaScript framework for building modern web apps.
      </I.Content>
    </A.Item>

    <A.Item class="item" @value="when" as |I|>
      <I.Header as |H|>
        <H.Trigger class="trigger">When should I use Accordion?</H.Trigger>
      </I.Header>
      <I.Content class="content">
        When you need controlled state, richer keyboard behavior, or design-system composition beyond native details.
      </I.Content>
    </A.Item>

    <A.Item class="item" @value="style" as |I|>
      <I.Header as |H|>
        <H.Trigger class="trigger">Can I style it myself?</H.Trigger>
      </I.Header>
      <I.Content class="content">
        Yes. Accordion is unstyled — bring your own CSS or design tokens.
      </I.Content>
    </A.Item>
  </Accordion>

  <style>
    .faq {
      display: grid;
      gap: 0.5rem;
      max-width: 28rem;
    }

    .item {
      border: 1px solid var(--doc-border);
      border-radius: 0.5rem;
      background: var(--doc-bg);
      overflow: hidden;
    }

    .trigger {
      display: flex;
      width: 100%;
      margin: 0;
      padding: 0.7rem 0.9rem;
      border: 0;
      background: transparent;
      color: var(--doc-text-1);
      font-family: var(--font-sans);
      font-size: 0.875rem;
      font-weight: 500;
      text-align: left;
      cursor: pointer;
    }

    .item[data-state="open"] .trigger {
      border-bottom: 1px solid var(--doc-border);
      background: var(--doc-bg-soft);
    }

    .content {
      padding: 0.8rem 0.9rem 1rem;
      font-family: var(--font-sans);
      font-size: 0.875rem;
      line-height: 1.55;
      color: var(--doc-text-2);
    }
  </style>
</template>
```

</div>

## Examples

<details open>
<summary><h3>Bootstrap - Single - Uncontrolled</h3></summary>

```gjs live preview
import { Accordion, Shadowed } from 'ember-primitives';

<template>
  <Shadowed>
    <Accordion class='accordion' @type='single' as |A|>
      <A.Item class='accordion-item' @value='what' as |I|>
        <I.Header class='accordion-header' as |H|>
          <H.Trigger
            aria-expanded='{{I.isExpanded}}'
            class='accordion-button {{unless I.isExpanded "collapsed"}}'
          >What is Ember?</H.Trigger>
        </I.Header>
        <I.Content class='accordion-collapse {{if I.isExpanded "show"}}'>
          <div class='accordion-body'>
            Ember.js is a productive, battle-tested JavaScript framework for building modern web
            applications. It includes everything you need to build rich UIs that work on any device.
          </div>
        </I.Content>
      </A.Item>
      <A.Item class='accordion-item' @value='why' as |I|>
        <I.Header class='accordion-header' as |H|>
          <H.Trigger
            aria-expanded='{{I.isExpanded}}'
            class='accordion-button {{unless I.isExpanded "collapsed"}}'
          >Why should I use Ember?</H.Trigger>
        </I.Header>
        <I.Content class='accordion-collapse {{if I.isExpanded "show"}}'>
          <div class='accordion-body'>
            Use Ember.js for its opinionated structure and extensive ecosystem, which simplify
            development and ensure long-term stability for web applications.
          </div>
        </I.Content>
      </A.Item>
    </Accordion>

    <link
      href='https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css'
      rel='stylesheet'
      crossorigin='anonymous'
    />

    <style>
      @scope {
        .accordion-body { color: black; }
      }
    </style>
  </Shadowed>
</template>
```

</details>

<details>
<summary><h3>Multiple - Uncontrolled</h3></summary>

```gjs live preview
import { Accordion } from 'ember-primitives';

<template>
  <Accordion @type='multiple' as |A|>
    <A.Item @value='what' as |I|>
      <I.Header as |H|>
        <H.Trigger>What is Ember?</H.Trigger>
      </I.Header>
      <I.Content>Ember.js is a productive, battle-tested JavaScript framework for building modern
        web applications. It includes everything you need to build rich UIs that work on any device.</I.Content>
    </A.Item>
    <A.Item @value='why' as |I|>
      <I.Header as |H|>
        <H.Trigger>Why should I use Ember?</H.Trigger>
      </I.Header>
      <I.Content>Use Ember.js for its opinionated structure and extensive ecosystem, which simplify
        development and ensure long-term stability for web applications.</I.Content>
    </A.Item>
  </Accordion>
</template>
```

</details>

<details>
<summary><h3>Single - Controlled - Collapsible</h3></summary>

```gjs live preview
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { Accordion } from 'ember-primitives';

export default class ControlledAccordion extends Component {
  <template>
    <Accordion
      @type='single'
      @collapsible={{true}}
      @value={{this.value}}
      @onValueChange={{this.updateValue}}
      as |A|
    >
      <A.Item @value='what' as |I|>
        <I.Header as |H|>
          <H.Trigger>What is Ember?</H.Trigger>
        </I.Header>
        <I.Content>Ember.js is a productive, battle-tested JavaScript framework for building modern
          web applications. It includes everything you need to build rich UIs that work on any
          device.</I.Content>
      </A.Item>
      <A.Item @value='why' as |I|>
        <I.Header as |H|>
          <H.Trigger>Why should I use Ember?</H.Trigger>
        </I.Header>
        <I.Content>Use Ember.js for its opinionated structure and extensive ecosystem, which
          simplify development and ensure long-term stability for web applications.</I.Content>
      </A.Item>
    </Accordion>
  </template>

  @tracked value = 'what';

  updateValue = (value) => {
    this.value = value;
  };
}
```

</details>

<details>
<summary><h3>Multiple - Controlled</h3></summary>

```gjs live preview
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';

import { Accordion } from 'ember-primitives';

export default class ControlledAccordion extends Component {
  <template>
    <Accordion @type='multiple' @value={{this.values}} @onValueChange={{this.updateValues}} as |A|>
      <A.Item @value='what' as |I|>
        <I.Header as |H|>
          <H.Trigger>What is Ember?</H.Trigger>
        </I.Header>
        <I.Content>Ember.js is a productive, battle-tested JavaScript framework for building modern
          web applications. It includes everything you need to build rich UIs that work on any
          device.</I.Content>
      </A.Item>
      <A.Item @value='why' as |I|>
        <I.Header as |H|>
          <H.Trigger>Why should I use Ember?</H.Trigger>
        </I.Header>
        <I.Content>Use Ember.js for its opinionated structure and extensive ecosystem, which
          simplify development and ensure long-term stability for web applications.</I.Content>
      </A.Item>
    </Accordion>
  </template>

  @tracked values = ['what', 'why'];

  updateValues = (values) => {
    this.values = values;
  };
}
```

</details>

## Install

```hbs live
<SetupInstructions @src="components/accordion.gts" @since="0.9.0" />
```

## Features

- Full keyboard navigation
- Can be controlled or uncontrolled
- Can expand one or multiple items
- Can be animated


## Anatomy

```js
import { Accordion } from 'ember-primitives';
```

or for non tree-shaking environments:

```js
import { Accordion } from 'ember-primitives/components/accordion';
```

```gjs
import { Accordion } from 'ember-primitives';

<template>
  <Accordion as |A|>
    <A.Item as |I|>
      <I.Header as |H|>
        <H.Trigger>Trigger</H.Trigger>
      </I.Header>
      <I.Content>Content</I.Content>
  </Accordion>
</template>
```

## API Reference

<details>
<summary><h3>Accordion</h3></summary>

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module='declarations/components/accordion' 
    @name='Accordion' 
  />
</template>
```

### State Attributes

|       key       | description                                  |
| :-------------: | :------------------------------------------- |
| `data-disabled` | Indicates whether the accordion is disabled. |

</details>

<details>
<summary><h3>AccordionItem</h3></summary>

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module='declarations/components/accordion' 
    @name='AccordionItemExternalSignature' 
  />
</template>
```

### State Attributes

|       key       | description                                                                           |
| :-------------: | :------------------------------------------------------------------------------------ |
|  `data-state`   | "open" or "closed", depending on whether the accordion item is expanded or collapsed. |
| `data-disabled` | Indicates whether the accordion item is disabled.                                     |

</details>

<details>
<summary><h3>AccordionHeader</h3></summary>

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module='declarations/components/accordion' 
    @name='AccordionHeaderExternalSignature' 
  />
</template>
```

### State Attributes

|       key       | description                                                                           |
| :-------------: | :------------------------------------------------------------------------------------ |
|  `data-state`   | "open" or "closed", depending on whether the accordion item is expanded or collapsed. |
| `data-disabled` | Indicates whether the accordion item is disabled.                                     |

</details>

<details>
<summary><h3>AccordionTrigger</h3></summary>

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module='declarations/components/accordion' 
    @name='AccordionTriggerExternalSignature' 
  />
</template>
```

### State Attributes

|       key       | description                                                                           |
| :-------------: | :------------------------------------------------------------------------------------ |
|  `data-state`   | "open" or "closed", depending on whether the accordion item is expanded or collapsed. |
| `data-disabled` | Indicates whether the accordion item is disabled.                                     |

</details>

<details>
<summary><h3>AccordionContent</h3></summary>

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module='declarations/components/accordion' 
    @name='AccordionContentExternalSignature' />
</template>
```

</details>

## Accessibility

- Sets `aria-expanded` on the accordion trigger to indicate whether the accordion item is expanded or collapsed.
- Uses `aria-controls` and `id` to associate the accordion trigger with the accordion content.
- Sets `hidden` on the accordion content when it is collapsed.

## Keyboard Interactions

|                key                | description                                    |
| :-------------------------------: | :--------------------------------------------- |
|          <kbd>Tab</kbd>           | Moves focus to the next focusable element.     |
| <kbd>Shift</kbd> + <kbd>Tab</kbd> | Moves focus to the previous focusable element. |
|         <kbd>Space</kbd>          | Toggles the accordion item.                    |
|         <kbd>Enter</kbd>          | Toggles the accordion item.                    |
