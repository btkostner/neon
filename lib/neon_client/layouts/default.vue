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
