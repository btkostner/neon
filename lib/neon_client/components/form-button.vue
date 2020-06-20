<template>
  <component
    :is="component"
    v-bind="binds"
    :class="classes"
    :disabled="disabled"
    v-on="listners"
  >
    <slot />
  </component>
</template>

<script>
export default {
  model: {
    prop: 'active',
    event: 'toggle'
  },

  props: {
    active: {
      type: Boolean,
      default: false
    },

    disabled: {
      type: Boolean,
      default: false
    },

    href: {
      type: String,
      default: ''
    },

    tag: {
      type: String,
      default: ''
    }
  },

  computed: {
    attributes () {
      if (this.disabled) {
        return {}
      }

      switch (this.component) {
        case 'nuxt-link':
          return { to: this.href }
        case 'a':
          return { href: this.href }
        default:
          return {}
      }
    },

    binds () {
      return { ...this.$attrs, ...this.attributes }
    },

    classes () {
      return {
        [this.$style.button]: true,
        [this.$style.active]: this.active,
        [this.$style.disabled]: this.disabled
      }
    },

    component () {
      if (this.tag !== '') {
        return this.tag
      } else if (this.hasHref && !this.disabled) {
        return 'nuxt-link'
      } else {
        return 'button'
      }
    },

    hasHref () {
      return (this.href !== '')
    },

    listners () {
      return {
        click: this.onClick,
        ...this.$listeners
      }
    }
  },

  methods: {
    onClick (e) {
      this.$emit('click', e)
      this.$emit('toggle', !this.active)
    }
  }
}
</script>

<style module>
  .button {
    -webkit-font-smoothing: antialiased;
    align-content: center;
    align-items: center;
    appearance: none;
    background-color: transparent;
    border-radius: 0.25em;
    border: 1px solid var(--blueberry-500);
    color: var(--blueberry-500);
    cursor: pointer;
    display: inline-flex;
    font-family: var(--ui-font);
    font-size: 0.9rem;
    justify-content: center;
    padding: 0.5rem 0.75rem;
    text-align: center;
    text-decoration: none;
    transition: all 100ms ease;
    user-select: none;
  }

  .active,
  .button:hover,
  .button:focus,
  .button:active {
    outline: none;
  }

  .disabled,
  .button:disabled {
    background-color: var(--slate-700);
    border-color: var(--slate-700);
    color: var(--slate-300);
    cursor: default;
    opacity: 0.6;
  }
</style>
