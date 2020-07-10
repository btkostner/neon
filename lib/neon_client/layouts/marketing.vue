<template>
  <div id="__page">
    <nuxt id="__page_content" />

    <layout-footer />
  </div>
</template>

<style scoped>
  #__page {
    display: flex;
    flex-direction: column;
  }

  #__page_content {
    flex-grow: 1;
  }
</style>
