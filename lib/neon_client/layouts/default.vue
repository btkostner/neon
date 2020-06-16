<template>
  <div id="__page">
    <layout-sidebar class="sidebar" />

    <div class="page">
      <div class="page__content">
        <nuxt />
      </div>

      <layout-footer />
    </div>
  </div>
</template>

<style>
  @import "~/assets/styles/variables.css";
  @import "~/assets/styles/main.css";
</style>

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
</style>

<script>
import LayoutFooter from '~/components/layout-footer'
import LayoutSidebar from '~/components/layout-sidebar'

export default {
  components: {
    LayoutFooter,
    LayoutSidebar
  }
}
</script>
