import { ApolloClient } from 'apollo-client'
import { createAbsintheSocketLink } from '@absinthe/socket-apollo-link'
import { restartWebsockets } from 'vue-cli-plugin-apollo/graphql-client'
import { InMemoryCache } from 'apollo-cache-inmemory'
import { Socket as PhoenixSocket } from 'phoenix'
import * as AbsintheSocket from '@absinthe/socket'
import Cookies from 'js-cookie'
import Vue from 'vue'
import VueApollo from 'vue-apollo'

const TOKEN_COOKIE = 'neon-token'

Vue.use(VueApollo)

export default (ctx, inject) => {
  const phoenixSocket = new PhoenixSocket('ws://localhost:4000/socket', {
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
    defaultClient: apolloClient
  })

  ctx.app.apolloProvider = apolloProvider

  inject('apolloHelpers', {
    onLogin (token) {
      Cookies.set(TOKEN_COOKIE, token)
      restartWebsockets(apolloClient.wsClient)
      return apolloClient.resetStore()
    },

    Logout () {
      Cookies.remove(TOKEN_COOKIE)
      restartWebsockets(apolloClient.wsClient)
      return apolloClient.resetStore()
    }
  })
}
