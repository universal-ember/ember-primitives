import { Avatar } from 'ember-primitives/components/avatar';

<template>
  <link href=" https://cdn.jsdelivr.net/npm/daisyui@5.1.27/daisyui.min.css " rel="stylesheet" />

  <div class="not-prose">
    <Avatar @src="https://img.daisyui.com/images/profile/demo/yellingwoman@192.webp" as |a|>
      <div class="avatar avatar-online">
        <div class="w-24 rounded-full">
          <a.Image alt="women pointing at a cat in frustration" />
        </div>
      </div>
    </Avatar>

    <Avatar
      class="w-24 rounded-full"
      @src="https://broken.tld/hi"
      as |a|
    >
      <div class="avatar avatar-offline avatar-placeholder">
        {{#if a.isError}}
          <a.Fallback>
            <div class="bg-neutral text-neutral-content w-16 rounded-full">
              <span class="text-xl">ope</span>
            </div>
          </a.Fallback>
        {{else}}
          <div class="w-24 rounded-full">
            <a.Image alt="intentially broken" />
          </div>
        {{/if}}
      </div>
    </Avatar>
</template>
