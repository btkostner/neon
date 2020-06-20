<template>
  <span
    v-bind="$attrs"
    :class="$style.error"
    v-on="$listeners"
  >
    <slot />
  </span>
</template>

<style module>
  .error {
    align-content: center;
    align-items: center;
    color: var(--strawberry-500);
    display: block;
    display: flex;
    font-family: var(--ui-font);
    font-size: 0.9rem;
    justify-content: flex-start;
    line-height: 1;
    margin: 0.3rem 0.75rem 0;
    min-height: 1.2rem;
    text-align: left;
    user-select: none;
  }
</style>
