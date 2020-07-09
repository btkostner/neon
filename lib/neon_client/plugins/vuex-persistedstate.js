import SecureLS from 'secure-ls'
import createPersistedState from 'vuex-persistedstate'

const ls = new SecureLS({ isCOmpression: false })

export default ({ store }) => {
  createPersistedState({
    key: 'neon',
    paths: ['auth'],
    storage: {
      getItem: (key) => ls.get(key),
      setItem: (key, value) => ls.set(key, value),
      removeItem: (key) => ls.remove(key)
    }
  })(store)
}
