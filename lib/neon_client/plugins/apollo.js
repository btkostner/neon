import { ApolloClient } from 'apollo-client'
import { createAbsintheSocketLink } from '@absinthe/socket-apollo-link'
import { InMemoryCache } from 'apollo-cache-inmemory'
import { Socket as PhoenixSocket } from 'phoenix'
import * as AbsintheSocket from '@absinthe/socket'
import Vue from 'vue'
import VueApollo from 'vue-apollo'

const socketProtocol = window.location.protocol.startsWith('https') ? 'wss' : 'ws'
const socketUrl = `${socketProtocol}://${window.location.host}/graphql`

Vue.use(VueApollo)

export default (ctx, inject) => {
  const phoenixSocket = new PhoenixSocket(socketUrl, {
    params: () => {
      const token = ctx.store.getters['auth/token']

      if (token != null) {
        return { token }
      } else {
        return {}
      }
    }
  })

  // TODO: we need to figure out a check to see if the close was due to an
  // authentication error or not
  // phoenixSocket.onClose(() => ctx.store.dispatch('auth/logout'))

  const absintheSocket = AbsintheSocket.create(phoenixSocket)
  const websocketLink = createAbsintheSocketLink(absintheSocket)
  const inMemoryCache = new InMemoryCache()

  const apolloClient = new ApolloClient({
    link: websocketLink,
    cache: inMemoryCache
  })

  // eslint-disable-next-line no-new
  ctx.app.apolloProvider = new VueApollo({
    defaultClient: apolloClient,

    watchLoading (isLoading, countModifier) {
      try {
        if (isLoading) {
          ctx.app.$nuxt.$loading.start()
        } else {
          ctx.app.$nuxt.$loading.stop()
        }
      } catch (err) {}
    }
  })

  inject('phoenixSocket', phoenixSocket)

  inject('apolloHelpers', {
    async reset () {
      await new Promise((resolve, reject) => {
        phoenixSocket.disconnect(() => resolve())
      })

      await apolloClient.resetStore()

      phoenixSocket.connect()
    },

    mutate (...args) {
      return apolloClient.mutate(...args)
    }
  })
}
