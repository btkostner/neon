<template>
  <div>
    <header>
      <div class="header__section">
        <div class="header__icon">
          <font-awesome-icon :icon="faSearch" />
        </div>

        <nuxt-link
          to="/stocks"
          class="header__item"
        >
          Stocks
        </nuxt-link>

        <transition name="animate">
          <div
            v-if="market || symbol"
            class="animate animate--1 header__icon"
          >
            <font-awesome-icon :icon="faAngleRight" />
          </div>
        </transition>

        <transition name="animate">
          <nuxt-link
            v-if="market"
            :to="`/stocks/${market}`"
            class="animate animate--2 header__item"
          >
            {{ market }}
          </nuxt-link>
        </transition>

        <transition name="animate">
          <div
            v-if="symbol"
            class="animate animate--3 header__icon"
          >
            <font-awesome-icon :icon="faAngleRight" />
          </div>
        </transition>

        <transition name="animate">
          <nuxt-link
            v-if="symbol"
            :to="`/stocks/${market}/${symbol}`"
            class="animate animate--4 header__item"
          >
            {{ symbol }}
          </nuxt-link>
        </transition>
      </div>

      <div class="header__icon">

      </div>
    </header>

    <div class="content">
      <nuxt-child />
    </div>
  </div>
</template>

<style scoped>
  header {
    align-content: stretch;
    align-items: stretch;
    background-color: var(--third-bg-color);
    color: var(--third-fg-color);
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    min-height: 3rem;
  }

  .header__section {
    display: flex;
    align-items: stretch;
    align-content: stretch;
  }

  .header__icon {
    align-content: center;
    align-items: center;
    display: flex;
    height: 3rem;
    justify-content: center;
    width: 3rem;
  }

  .header__item {
    align-content: center;
    align-items: center;
    display: flex;
    justify-content: center;
    padding: 1ch;
  }

  .header__item:hover,
  .header__item:focus {
    box-shadow: inset 0 -0.5ch 0 0 var(--blueberry-500);
  }

  .animate {
    left: 0;
    opacity: 1;
    position: relative;
  }

  .animate-enter,
  .animate-leave-to {
    left: -40px;
    opacity: 0;
  }

  .animate--1-enter-active {
    transition: all 200ms linear 50ms;
  }

  .animate--1-leave-active {
    transition: all 200ms linear 400000000;
  }

  .animate--2-enter-active {
    transition: all 250ms linear 100ms;
  }

  .animate--3-enter-active {
    transition: all 300ms linear 150ms;
  }

  .animate--4-enter-active {
    transition: all 350ms linear 200ms;
  }
</style>

<script>
import { faAngleRight, faSearch } from '@fortawesome/free-solid-svg-icons'

export default {
  auth: 'user',

  data: () => ({
    faAngleRight,
    faSearch,

    isSearching: false
  }),

  computed: {
    market () {
      if (this.$route.params.market) {
        return this.$route.params.market.toUpperCase()
      } else {
        return null
      }
    },

    symbol () {
      if (this.$route.params.symbol) {
        return this.$route.params.symbol.toUpperCase()
      } else {
        return null
      }
    }
  },

  methods: {
    toggleSearching () {
      this.isSearching = !this.isSearching
    }
  }
}
</script>
