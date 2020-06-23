import { ApolloClient } from 'apollo-client'
import { createAbsintheSocketLink } from '@absinthe/socket-apollo-link'
import { InMemoryCache } from 'apollo-cache-inmemory'
import { Socket as PhoenixSocket } from 'phoenix'
import * as AbsintheSocket from '@absinthe/socket'
import Cookies from 'js-cookie'
import Vue from 'vue'
import VueApollo from 'vue-apollo'

const TOKEN_COOKIE = 'neon-token'

const socketUrl = (env) => {
  switch (env) {
    case 'test':
      return 'ws://localhost:4002/socket'
    case 'production':
      return 'wss://neon.btkostner.io/socket'
    default:
      return 'ws://localhost:4000/socket'
  }
}

Vue.use(VueApollo)

export default (ctx, inject) => {
  const phoenixSocket = new PhoenixSocket(socketUrl(process.env.MIX_ENV), {
    params: () => {
      const token = Cookies.get(TOKEN_COOKIE)

      if (token != null) {
        return { token }
      } else {
        return {}
      }
    }
  })

  const absintheSocket = AbsintheSocket.create(phoenixSocket)
  const websocketLink = createAbsintheSocketLink(absintheSocket)
  const inMemoryCache = new InMemoryCache()

  const apolloClient = new ApolloClient({
    link: websocketLink,
    cache: inMemoryCache
  })

  const apolloProvider = new VueApollo({
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

  ctx.app.apolloProvider = apolloProvider

  inject('apolloHelpers', {
    async login (token, expires) {
      Cookies.set(TOKEN_COOKIE, token, {
        expires: expires || 1,
        sameSite: 'strict'
      })

      await new Promise((resolve, reject) => {
        phoenixSocket.disconnect(() => resolve())
      })

      await apolloClient.resetStore()

      phoenixSocket.connect()
    },

    async logout () {
      Cookies.remove(TOKEN_COOKIE)

      await new Promise((resolve, reject) => {
        phoenixSocket.disconnect(() => resolve())
      })

      await apolloClient.resetStore()

      phoenixSocket.connect()
    }
  })
}
