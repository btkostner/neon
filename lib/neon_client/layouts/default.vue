<template>
  <transition
    name="default-layout"
    mode="out-in"
    appear
    :css="false"
    @enter="animateLayoutIn"
  >
    <div id="__page">
      <div
        class="sidebar"
        style="overflow: hidden;"
      >
        <div class="sidebar__links">
          <nuxt-link class="sidebar__link" to="/dashboard">
            Dashboard
          </nuxt-link>

          <nuxt-link class="sidebar__link" to="/stocks">
            Stocks
          </nuxt-link>
        </div>

        <transition
          name="sidebar-settings"
          mode="out-in"
          :css="false"
          @enter="animateSettingsIn"
          @leave="animateSettingsOut"
        >
          <div
            v-if="showSettings"
            class="sidebar__settings"
          >
            <a
              v-if="isAdmin"
              class="sidebar__link"
              href="/system/debug"
              @click="toggleSettings"
            >
              Debug System
            </a>

            <a
              v-if="isAdmin"
              class="sidebar__link"
              href="/system/graphql"
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
              <font-awesome-icon :icon="faAngleUp" />
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

      <div
        class="page"
        style="overflow: hidden;"
      >
        <div class="page__content">
          <nuxt />
        </div>

        <layout-footer class="page__footer" />
      </div>
    </div>
  </transition>
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
    background-color: var(--second-bg-color);
    color: var(--second-fg-color);
    display: flex;
    flex-direction: column;
    height: 100vh;
    min-width: 20ch;
    overflow-y: auto;
  }

  .sidebar__links {
    flex: 1 0 auto;
  }

  .sidebar__link {
    color: inherit;
    display: block;
    margin: 0 1px 0 0;
    opacity: 0;
    padding: 0.8rem 1rem;
    transition: all 120ms ease;
    user-select: none;
  }

  .sidebar__link.nuxt-link-active {
    background-color: var(--first-bg-color);
    box-shadow: inset 0.5ch 0 0 0 var(--second-bg-color);
    color: var(--first-fg-color);
  }

  .sidebar__link:hover,
  .sidebar__link:focus {
    box-shadow: inset 0.5ch 0 0 0 var(--blueberry-700);
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
    display: block;
    height: 100%;
    width: 100%;
  }

  .avatar__activity {
    border-radius: 4px;
    height: 8px;
    left: -4px;
    position: absolute;
    top: -4px;
    width: 8px;
    z-index: 3;
  }

  .avatar__activity--offline {
    background-color: var(--strawberry-300);
    box-shadow: 0 0 0 1px var(--strawberry-700);
  }

  .avatar__activity--online {
    background-color: var(--lime-300);
    box-shadow: 0 0 0 1px var(--lime-700);
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
    color: var(--silver-700);
    font-size: 0.9rem;
    grid-column: 2 / 3;
    grid-row: 2 / 3;
  }

  .avatar:hover .avatar__hover,
  .avatar:focus-within .avatar__hover {
    opacity: 1;
  }

  .avatar:hover .avatar__subtitle,
  .avatar:focus-within .avatar__subtitle {
    text-decoration: underline;
  }
</style>

<script>
import { faAngleUp } from '@fortawesome/free-solid-svg-icons'
import anime from 'animejs'
import gql from 'graphql-tag'
import { mapGetters } from 'vuex'

export default {
  apollo: {
    profile: gql`query {
      profile: accountProfile{
        name
        avatar
      }
    }`
  },

  data: () => ({
    faAngleUp,

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
    animateLayoutIn (el, done) {
      const animation = anime
        .timeline({
          easing: 'easeOutExpo'
        })
        .add({
          targets: el.querySelector('#__page > .sidebar'),
          translateX: [-200, 0],
          opacity: [0, 1],
          duration: 1000,
          complete: () => {
            el.querySelector('.sidebar').style.overflow = null
          }
        }, '0')
        .add({
          targets: el.querySelectorAll('.sidebar .sidebar__links .sidebar__link'),
          translateX: [-20, 0],
          transalteY: [-10, 0],
          opacity: [0, 1],
          delay: anime.stagger(100),
          duration: 600
        }, '300')
        .add({
          targets: el.querySelector('.sidebar .sidebar__avatar'),
          translateY: [50, 0],
          opacity: [0, 1],
          duration: 1000
        }, '300')
        .add({
          targets: el.querySelector('.page > .page__content'),
          opacity: [0, 1],
          duration: 1000
        }, '300')
        .add({
          targets: el.querySelectorAll('.page > .page__footer > *'),
          translateY: [50, 0],
          opacity: [0, 1],
          delay: anime.stagger(80),
          duration: 1200,
          complete: () => {
            el.querySelector('.page').style.overflow = null
          }
        }, '500')

      animation.finished.then(done)
    },

    animateSettingsIn (el, done) {
      const animation = anime
        .timeline({
          easing: 'easeOutExpo'
        })
        .add({
          targets: el.querySelectorAll('.sidebar__link'),
          translateY: [25, 0],
          opacity: [0, 1],
          delay: anime.stagger(60, { direction: 'reverse' }),
          duration: 400
        })

      animation.finished.then(done)
    },

    animateSettingsOut (el, done) {
      const animation = anime
        .timeline({
          easing: 'easeOutExpo'
        })
        .add({
          targets: el.querySelectorAll('.sidebar__link'),
          translateY: [0, 20],
          opacity: [1, 0],
          delay: anime.stagger(50),
          duration: 45
        }, 0)

      animation.finished.then(done)
    },

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
