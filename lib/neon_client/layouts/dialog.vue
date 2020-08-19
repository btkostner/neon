<template>
  <div id="__page" class="page">
    <div class="page__content">
      <nuxt class="page__dialog" />
    </div>

    <layout-footer />
  </div>
</template>

<style scoped>
  .page {
    background-color: var(--second-bg-color);
    color: var(--second-fg-color);
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
    animation: breath 10s ease alternate infinite;
    border-radius: 6px;
    border: 1px solid var(--blueberry-500);
    box-shadow: 0 0 25px var(--blueberry-700);
    color: var(--silver-100);
    margin: 2rem 0 0 0;
    padding: 2rem;
    transition: all 200ms linear;
  }

  .page__dialog >>> > :first-child {
    margin-top: 0;
  }

  .page__dialog >>> > :last-child {
    margin-bottom: 0;
  }

  .page__dialog >>> h1,
  .page__dialog >>> h2 {
    text-align: center;
  }

  @keyframes breath {
    0% {
      border-color: var(--blueberry-500);
      box-shadow: 0 0 25px var(--blueberry-700);
    }

    20% {
      box-shadow: 0 0 30px var(--blueberry-500);
    }

    40% {
      box-shadow: 0 0 20px var(--blueberry-700);
    }

    60% {
      border-color: var(--blueberry-700);
      box-shadow: 0 0 20px var(--blueberry-700);
    }

    80% {
      border-color: var(--blueberry-500);
    }

    100% {
      box-shadow: 0 0 25px var(--blueberry-700);
    }
  }
</style>
