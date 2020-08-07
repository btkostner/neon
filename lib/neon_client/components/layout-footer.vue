<template>
  <footer>
    <span>
      Written with love by Blake Kostner
    </span>

    <span>
      Source code available on <a href="https://github.com/btkostner/neon">GitHub</a>
    </span>
  </footer>
</template>

<style scoped>
  footer {
    color: var(--silver-700);
    display: flex;
    flex-wrap: wrap;
    font-family: var(--ui-font);
    justify-content: space-between;
    padding: 1rem;
    user-select: none;
  }

  a {
    color: inherit;
    opacity: 1;
  }
</style>
