<template>
  <validation-observer
    ref="observer"
    v-slot="binds"
    :class="$style.form"
    :disabled="disabled"
    tag="form"
    @submit.prevent="submit"
  >
    <h1
      v-if="headerText"
      :class="$style.header"
    >
      {{ headerText }}
    </h1>

    <slot
      name="error"
      v-bind="{ errorMessage }"
    >
      <span v-if="errorMessage">
        {{ errorMessage }}
      </span>
    </slot>

    <slot v-bind="{ submitting, ...binds }" />

    <div :class="$style.actions">
      <slot
        name="actions"
        v-bind="{ submitting, submittable: (binds.valid && !submitting), ...binds }"
      >
        <form-button
          :disabled="!binds.valid || submitting"
          @click.prevent="submit"
        >
          {{ submitText }}
        </form-button>
      </slot>
    </div>
  </validation-observer>
</template>

<script>
import { ValidationObserver } from 'vee-validate'

export default {
  components: {
    ValidationObserver
  },

  inheritAttrs: false,

  props: {
    disabled: {
      type: Boolean,
      default: false
    },

    headerText: {
      type: String,
      default: ''
    },

    submitFunction: {
      type: Function,
      default: () => null
    },

    submitText: {
      type: String,
      default: 'Submit'
    },

    swallowError: {
      type: Boolean,
      default: true
    }
  },

  data: () => ({
    errorMessage: '',

    submitting: false
  }),

  errorCaptured (err, vm, info) {
    this.handleError(err, vm, info)
  },

  methods: {
    handleError (err, vm, info) {
      // eslint-disable-next-line no-console
      console.error(err)
      this.errorMessage = err.message

      if (!this.swallowError) {
        this.$nuxt.error({
          statusCode: 500,
          message: this.errorMessage
        })
      }
    },

    async submit (e) {
      if (this.disabled) {
        e.preventDefault()
        return false
      }

      this.errorMessage = ''
      this.submitting = true

      try {
        const valid = await this.$refs.observer.validate()

        if (!valid) {
          e.preventDefault()
          return false
        } else {
          await this.submitFunction()
        }
      } catch (err) {
        this.handleError(err)
      } finally {
        this.submitting = false
      }
    }
  }
}
</script>

<style module>
  .form {
    display: grid;
    margin: 1rem;
    grid-gap: 0.4rem 1rem;
    padding: 0;
  }

  .header {
    margin-bottom: 2rem;
  }

  .actions {
    align-content: center;
    align-items: center;
    display: flex;
    flex-wrap: wrap;
    justify-content: flex-end;
  }
</style>
