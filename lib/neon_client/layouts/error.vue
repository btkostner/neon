<template>
  <transition
    name="error-layout"
    appear
    :css="false"
    @enter="animateLayoutIn"
  >
    <div class="error">
      <h1>{{ code }}</h1>

      <h2 v-if="message">
        {{ message }}
      </h2>

      <pre v-if="details">
        <code>
          {{ details }}
        </code>
      </pre>

      <div class="links">
        <button @click.prevent="refresh">
          Refresh
        </button>

        <nuxt-link to="/dashboard">
          Dashboard
        </nuxt-link>
      </div>
    </div>
  </transition>
</template>

<style scoped>
  .error {
    align-content: center;
    align-items: center;
    background-color: rgba(45, 21, 21, 0);
    display: flex;
    flex-direction: column;
    justify-content: center;
    width: 100vw;
  }

  .links {
    margin-top: 2rem;
  }

  .links > * {
    -webkit-font-smoothing: antialiased;
    align-content: center;
    align-items: center;
    appearance: none;
    background-color: transparent;
    border-radius: 0.25em;
    border: 1px solid var(--strawberry-300);
    color: var(--strawberry-100);
    cursor: pointer;
    display: inline-flex;
    font-size: 1rem;
    justify-content: center;
    line-height: 1;
    margin: 0 1rem;
    padding: 0.75rem;
    text-align: center;
    text-decoration: none;
    text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
    transition: all 100ms ease;
    user-select: none;
  }

  .links > *:hover,
  .links > *:focus,
  .links > *:active {
    outline: none;
  }
</style>

<script>
import anime from 'animejs'

export default {
  layout: 'blank',

  props: {
    error: {
      type: [Error, Object],
      default: () => {}
    }
  },

  computed: {
    code () {
      return this.error.statusCode || 404
    },

    debug () {
      return (process.env.NODE_ENV === 'development')
    },

    details () {
      return this.error.details
    },

    message () {
      return this.error.message
    }
  },

  methods: {
    animateLayoutIn (el, done) {
      this.$nextTick(() => {
        const animation = anime
          .timeline({
            easing: 'easeOutExpo'
          })
          .add({
            targets: el,
            backgroundColor: ['rgba(45, 21, 21, 0)', 'rgba(45, 21, 21, 1)'],
            duration: 1500
          }, '500')
          .add({
            targets: el,
            color: ['rgba(255, 255, 255, 0)', 'rgba(255, 255, 255, 1)'],
            duration: 1000
          }, '1000')
          .add({
            targets: el.querySelectorAll('*'),
            opacity: [0, 1],
            translateY: [50, 0],
            delay: anime.stagger(90),
            duration: 900
          }, '800')

        animation.finished.then(done)
      })
    },

    refresh () {
      window.location.reload(true)
    }
  },

  head () {
    return {
      title: this.message
    }
  }
}
</script>
