<template>
  <div id="__page" class="page">
    <div class="page__content">
      <div class="page__dialog">
        <nuxt />
      </div>
    </div>

    <layout-footer />
  </div>
</template>

<style>
  @import "~/assets/styles/variables.css";
  @import "~/assets/styles/main.css";
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
    background-color: var(--secondary-bg-color);
    border-radius: 6px;
    border: 1px solid var(--black-900);
    margin: 2rem 0 0 0;
    padding: 1rem;
    transition: all 200ms linear;
  }

  .page__dialog:focus-within {
    background-color: var(--bg-color);
    border-color: var(--blueberry-500);
    box-shadow: 0 0 25px var(--blueberry-700);
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
