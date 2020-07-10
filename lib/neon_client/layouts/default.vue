<template>
  <div id="__page">
    <div class="sidebar">
      <div class="sidebar__links">
        <nuxt-link class="sidebar__link" to="/dashboard">
          Dashboard
        </nuxt-link>
      </div>

      <div class="sidebar__avatar avatar">
        <div class="avatar__look">
          <img
            v-if="!$apollo.queries.profile.loading"
            class="avatar__image"
            :src="`${profile.gravatarUrl}?s=48`"
            :alt="profile.name"
          >

          <div
            :class="{
              'avatar__activity': true,
              'avatar__activity--offline': $nuxt.isOffline,
              'avatar__activity--online': $nuxt.isOnline
            }"
          />
        </div>

        <span class="avatar__title">
          {{ profile.name }}
        </span>

        <span class="avatar__subtitle">
          Settings
        </span>
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
    overflow-y: auto;
  }

  .sidebar__links {
    flex: 1 0 auto;
  }

  .sidebar__link {
    color: inherit;
    display: block;
    opacity: 1;
    padding: 1rem;
    text-decoration: none;
  }

  .sidebar__link.nuxt-link-active {
    background-color: var(--blueberry-300);
    color: var(--slate-700);
  }

  .sidebar__avatar {
    flex: 0 0 auto;
    padding: 1rem;
  }

  .avatar {
    display: grid;
    align-items: center;
    align-content: center;
    grid-gap: 0 1ch;
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

  .avatar__title {
    grid-column: 2 / 3;
    grid-row: 1 / 2;
  }

  .avatar__subtitle {
    grid-column: 2 / 3;
    grid-row: 2 / 3;
    font-size: 0.8rem;
    color: var(--silver-500);
  }
</style>

<script>
import gql from 'graphql-tag'

export default {
  apollo: {
    profile: gql`query {
      profile{
        name
        gravatarUrl
      }
    }`
  },

  data: () => ({
    profile: {
      name: 'Loading...',
      gravatar: ''
    }
  })
}
</script>
