<template>
  <label
    :class="classes"
    v-on="$listeners"
  >
    <slot />
  </label>
</template>

<script>
export default {
  props: {
    invalid: {
      type: Boolean,
      default: false
    }
  },

  computed: {
    classes () {
      return {
        [this.$style.label]: true,
        [this.$style.invalid]: this.invalid
      }
    }
  }
}
</script>

<style module>
  .label {
    display: block;
    font-size: 0.9rem;
    padding: 0.2rem 0.75rem;
    text-align: left;
    user-select: none;
  }

  .invalid {
    color: var(--strawberry-500);
  }
</style>
