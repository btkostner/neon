<template>
  <input
    :disabled="disabled"
    :class="classes"
    :value="value"
    @blur="onBlur"
    @change="onChange"
    @focus="onFocus"
    @input="onInput"
  >
</template>

<script>
export default {
  model: {
    event: 'value'
  },

  props: {
    disabled: {
      type: Boolean,
      default: false
    },

    invalid: {
      type: Boolean,
      default: false
    },

    value: {
      type: [String, Number],
      default: ''
    }
  },

  computed: {
    classes () {
      return {
        [this.$style.input]: true,
        [this.$style.invalid]: this.invalid
      }
    }
  },

  methods: {
    onBlur (e) {
      this.$emit('blur', e)
    },

    onChange (e) {
      this.$emit('change', e)
    },

    onFocus (e) {
      this.$emit('focus', e)
    },

    onInput (e) {
      this.$emit('input', e)
      this.$emit('value', e.target.value)
    }
  }
}
</script>

<style module>
  .input {
    background-color: transparent;
    background-image: none;
    border-radius: 3px;
    border: 1px solid var(--slate-500);
    color: var(--silver-500);
    display: block;
    font-family: var(--copy-font);
    font-size: 1rem;
    margin: 0;
    padding: 0.5rem 0.75rem;
    transition: all 100ms ease;
    vertical-align: middle;
    width: 100%;
  }

  .input::-webkit-calendar-picker-indicator {
    display: none;
  }

  .input::-webkit-list-button {
    display: none;
  }

  /**
   * States
   */

  .invalid {
    border-color: var(--strawberry-500);
    color: var(--strawberry-500);
  }

  .input:hover,
  .input:focus,
  .input:active {
    outline: none;
  }

  .input:hover {
    border-color: var(--blueberry-300);
    color: var(--silver-300);
  }

  .input:focus,
  .input:active {
    border-color: var(--blueberry-500);
    color: var(--silver-100);
    outline: none;
  }

  .input:disabled {
    background-color: var(--slate-500);
    border-color: var(--slate-500);
    box-shadow: none;
    color: inherit;
    cursor: default;
    opacity: 0.4;
  }
</style>
