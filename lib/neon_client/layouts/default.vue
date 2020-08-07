<template>
  <div id="__page">
    <div class="sidebar">
      <div class="sidebar__links">
        <nuxt-link class="sidebar__link" to="/dashboard">
          Dashboard
        </nuxt-link>

        <nuxt-link class="sidebar__link" to="/stocks">
          Stocks
        </nuxt-link>
      </div>

      <transition name="slide-up">
        <div
          v-if="showSettings"
          class="sidebar__settings"
        >
          <a
            v-if="isAdmin"
            class="sidebar__link"
            href="/debug"
            @click="toggleSettings"
          >
            Debug System
          </a>

          <a
            v-if="isAdmin"
            class="sidebar__link"
            href="/graphiql"
            @click="toggleSettings"
          >
            Debug GraphQL
          </a>

          <nuxt-link
            class="sidebar__link"
            to="/auth/logout"
          >
            Log Out
          </nuxt-link>
        </div>
      </transition>

      <div
        class="sidebar__avatar avatar"
        @click.prevent="toggleSettings"
      >
        <div class="avatar__look">
          <img
            v-if="!$apollo.queries.profile.loading && profile"
            class="avatar__image"
            :src="`${profile.avatar}?s=48`"
            :alt="profile.name"
          >

          <div :class="avatarActivityClasses" />

          <div :class="avatarHoverClasses">
            <font-awesome-icon icon="angle-up" />
          </div>
        </div>

        <span class="avatar__title">
          {{ profile.name }}
        </span>

        <a href="#" class="avatar__subtitle">
          Settings
        </a>
      </div>
    </div>

    <div class="page">
      <div class="page__content">
        <nuxt />
      </div>

      <layout-footer />
    </div>
  </div>
</template>

<style scoped>
  #__page {
    display: grid;
    grid-template-columns: auto 1fr;
  }

  .page {
    display: flex;
    flex-direction: column;
    overflow-y: auto;
  }

  .page__content {
    flex: 1 0 auto;
  }

  .sidebar {
    background-color: var(--secondary-bg-color);
    color: var(--secondary-fg-color);
    display: flex;
    flex-direction: column;
    font-family: var(--ui-font);
    height: 100vh;
    min-width: 20ch;
    overflow-y: auto;
  }

  .sidebar__links {
    flex: 1 0 auto;
  }

  .sidebar__link {
    border-radius: 6px;
    color: inherit;
    display: block;
    margin: 0.6rem;
    opacity: 1;
    padding: 0.6rem 1rem;
    text-decoration: none;
    transition: all 80ms ease;
    user-select: none;
  }

  .sidebar__link:hover,
  .sidebar__link:focus,
  .sidebar__link.nuxt-link-active {
    background-color: var(--bg-color);
    color: var(--fg-color);
  }

  .sidebar__avatar {
    flex: 0 0 auto;
    padding: 1rem;
  }

  .avatar {
    align-content: center;
    align-items: center;
    display: grid;
    grid-gap: 0 1ch;
    grid-template-columns: auto 1fr;
    user-select: none;
  }

  .avatar__look {
    background-color: var(--black-900);
    grid-column: 1 / 2;
    grid-row: 1 / 3;
    height: 48px;
    position: relative;
    width: 48px;
  }

  .avatar__image {
    border-radius: 6px;
    box-shadow: 0 0 0 1px var(--black-700);
    display: block;
    height: 100%;
    width: 100%;
  }

  .avatar__activity {
    border-radius: 8px;
    height: 12px;
    left: -6px;
    position: absolute;
    top: -6px;
    width: 12px;
    z-index: 3;
  }

  .avatar__activity--offline {
    background-color: var(--strawberry-300);
    box-shadow:
      inset 0 0 0 1px var(--strawberry-100),
      0 0 0 1px var(--strawberry-700);
  }

  .avatar__activity--online {
    background-color: var(--lime-300);
    box-shadow:
      inset 0 0 0 1px var(--lime-100),
      0 0 0 1px var(--lime-700);
  }

  .avatar__hover {
    align-content: center;
    align-items: center;
    background-color: rgba(0, 0, 0, 0.75);
    border-radius: 6px;
    bottom: 0;
    display: flex;
    justify-content: center;
    left: 0;
    opacity: 0;
    position: absolute;
    right: 0;
    top: 0;
    transition: opacity 100ms ease;
    z-index: 2;
  }

  .avatar__hover svg {
    transition: transform 200ms ease;
  }

  .avatar__hover--up svg {
    transform: rotate(0);
  }

  .avatar__hover--down svg {
    transform: rotate(180deg);
  }

  .avatar__title {
    grid-column: 2 / 3;
    grid-row: 1 / 2;
    white-space: nowrap;
  }

  .avatar__subtitle {
    color: var(--silver-500);
    font-size: 0.8rem;
    grid-column: 2 / 3;
    grid-row: 2 / 3;
    text-decoration: none;
  }

  .avatar:hover .avatar__hover,
  .avatar:focus-within .avatar__hover {
    opacity: 1;
  }

  .avatar:hover .avatar__subtitle,
  .avatar:focus-within .avatar__subtitle {
    text-decoration: underline;
  }

  .slide-up-enter-active,
  .slide-up-leave-active {
    transition: all 150ms ease;
  }

  .slide-up-enter,
  .slide-up-leave-to {
    opacity: 0;
    transform: scale(0.8) translate(-16px, 32px);
  }
</style>

<script>
import { faAngleUp } from '@fortawesome/free-solid-svg-icons'
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import gql from 'graphql-tag'
import { mapGetters } from 'vuex'

library.add(faAngleUp)

export default {
  components: {
    FontAwesomeIcon
  },

  apollo: {
    profile: gql`query {
      profile: accountProfile{
        name
        avatar
      }
    }`
  },

  data: () => ({
    profile: {
      name: 'Loading...',
      avatar: ''
    },

    showSettings: false,

    isOnline: false,
    isOnlineRefs: []
  }),

  computed: {
    ...mapGetters('auth', ['isAdmin']),

    avatarActivityClasses () {
      return {
        avatar__activity: true,
        'avatar__activity--offline': !this.isOnline,
        'avatar__activity--online': this.isOnline
      }
    },

    avatarHoverClasses () {
      return {
        avatar__hover: true,
        'avatar__hover--up': !this.showSettings,
        'avatar__hover--down': this.showSettings
      }
    }
  },

  beforeDestroy () {
    this.unregisterOnlineWatchers()
  },

  beforeMount () {
    this.registerOnlineWatchers()
  },

  methods: {
    registerOnlineWatchers () {
      this.isOnline = this.$phoenixSocket.isConnected()

      const onRef = this.$phoenixSocket.onOpen(() => (this.isOnline = true))
      this.isOnlineRefs.push(onRef)

      const offRef = this.$phoenixSocket.onClose(() => (this.isOnline = false))
      this.isOnlineRefs.push(offRef)
    },

    toggleSettings () {
      this.showSettings = !this.showSettings
    },

    unregisterOnlineWatchers () {
      this.isOnlineRefs.forEach((ref) => {
        this.$phoenixSocket.off(ref)
      })
    }
  }
}
</script>
