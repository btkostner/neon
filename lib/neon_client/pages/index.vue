<template>
  <div class="page">
    <h1>Project Neon</h1>

    <div class="actions">
      <template v-if="isLoggedIn">
        <nuxt-link to="/dashboard">
          Dashboard
        </nuxt-link>
      </template>

      <template v-else>
        <nuxt-link to="/auth/register">
          Register
        </nuxt-link>

        <nuxt-link to="/auth/login">
          Login
        </nuxt-link>
      </template>
    </div>
  </div>
</template>

<style scoped>
  .page {
    align-content: center;
    align-items: center;
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 1rem;
  }

  h1 {
    font-size: 4rem;
  }

  .actions {
    display: flex;
    flex-direction: column;
    margin-top: 2rem;
    text-align: center;
  }

  a:nth-child(1) {
    -webkit-font-smoothing: antialiased;
    align-content: center;
    align-items: center;
    animation: breath 10s ease alternate infinite;
    appearance: none;
    background-color: transparent;
    border-radius: 0.25em;
    border: 1px solid var(--blueberry-500);
    color: var(--blueberry-500);
    cursor: pointer;
    display: inline-flex;
    font-family: var(--ui-font);
    font-size: 1.2rem;
    justify-content: center;
    padding: 0.5rem 0.75rem;
    text-align: center;
    text-decoration: none;
    transition: all 100ms ease;
    user-select: none;
  }

  a:nth-child(2) {
    text-decoration: none;
    color: inherit;
    font-size: 0.9rem;
    margin-top: 1.2rem;
  }

  @keyframes breath {
    0% {
      border-color: var(--blueberry-500);
      box-shadow: 0 0 15px var(--blueberry-700);
    }

    20% {
      box-shadow: 0 0 20px var(--blueberry-500);
    }

    40% {
      box-shadow: 0 0 10px var(--blueberry-700);
    }

    60% {
      border-color: var(--blueberry-700);
      box-shadow: 0 0 10px var(--blueberry-700);
    }

    80% {
      border-color: var(--blueberry-500);
    }

    100% {
      box-shadow: 0 0 15px var(--blueberry-700);
    }
  }
</style>

<script>
import { mapGetters } from 'vuex'

export default {
  layout: 'marketing',
  auth: false,

  computed: {
    ...mapGetters('auth', ['isLoggedIn'])
  }
}
</script>
