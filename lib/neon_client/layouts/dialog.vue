<template>
  <div id="__page" class="page">
    <div class="page__content">
      <nuxt class="page__dialog" />
    </div>

    <layout-footer />
  </div>
</template>

<style>
  @import "~/assets/styles/variables.css";
  @import "~/assets/styles/main.css";
  @import "~/assets/styles/typography.css";
</style>

<style scoped>
  .page {
    display: flex;
    flex-direction: column;
  }

  .page__content {
    align-content: center;
    align-items: center;
    display: flex;
    flex-direction: column;
    flex: 1 0 auto;
    justify-content: center;
  }

  .page__dialog {
    border-radius: 6px;
    border: 1px solid var(--blueberry-500);
    box-shadow: 0 0 25px var(--blueberry-700);
    color: var(--silver-100);
    margin: 2rem 0 0 0;
    padding: 2rem;
    transition: all 200ms linear;
  }

  .page__dialog >>> >:first-child {
    margin-top: 0;
  }

  .page__dialog >>> >:last-child {
    margin-bottom: 0;
  }

  .page__dialog >>> h1,
  .page__dialog >>> h2 {
    text-align: center;
  }
</style>

<script>
import LayoutFooter from '~/components/layout-footer'

export default {
  components: {
    LayoutFooter
  }
}
</script>
