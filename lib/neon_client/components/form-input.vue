<template>
  <validation-provider
    v-slot="{ errors, required, ariaInput, ariaMsg }"
    :class="$style.formgroup"
    :disabled="disabled"
    :name="id"
    :rules="validation"
    tag="div"
  >
    <basic-label
      :for="id"
      :invalid="errors[0] != null"
    >
      {{ label }}
    </basic-label>

    <basic-input
      :id="id"
      v-bind="{...ariaInput, ...$attrs}"
      :disabled="disabled"
      :invalid="errors[0] != null"
      :required="required"
      @blur="onBlur"
      @change="onChange"
      @focus="onFocus"
      @input="onInput"
    />

    <basic-input-error v-bind="ariaMsg">
      {{ errors[0] }}
    </basic-input-error>
  </validation-provider>
</template>

<script>
import { ValidationProvider } from 'vee-validate'

export default {
  components: {
    ValidationProvider
  },

  inheritAttrs: false,

  model: {
    event: 'value'
  },

  props: {
    disabled: {
      type: Boolean,
      default: false
    },

    id: {
      type: String,
      required: true
    },

    label: {
      type: String,
      required: true
    },

    validation: {
      type: [String, Object],
      default: ''
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
  .formgroup {
    margin: 0;
    padding: 0;
  }
</style>
