import gql from 'graphql-tag'

export const state = () => ({
  token: null,
  expires: null,
  role: null
})

export const getters = {
  token (state, getters) {
    return (getters.isLoggedIn) ? state.token : null
  },

  isGuest (state, getters) {
    return !getters.isLoggedIn
  },

  isLoggedIn (state) {
    if (state.expires != null) {
      return (new Date(state.expires).getTime() >= new Date().getTime())
    } else {
      return false
    }
  },

  isUser (state) {
    return ['user', 'admin'].includes(state.role)
  },

  isAdmin (state) {
    return (state.role === 'admin')
  }
}

export const mutations = {
  login (state, data) {
    state.token = data.token
    state.expires = data.expiredAt
    state.role = data.user.role
  },

  logout (state) {
    state.token = null
    state.expires = null
    state.role = null
  }
}

export const actions = {
  async login ({ commit }, { email, password }) {
    const res = await this.$apolloHelpers.mutate({
      mutation: gql`mutation ($email: String!, $password: String!) {
        login(email: $email, password: $password) {
          token
          expiredAt
          user {
            role
          }
        }
      }`,
      variables: { email, password }
    })

    commit('login', res.data.login)
    this.$apolloHelpers.reset()
  },

  logout ({ commit }) {
    commit('logout')
    this.$apolloHelpers.reset()
  },

  async register ({ commit }, { name, email, password }) {
    const res = await this.$apolloHelpers.mutate({
      mutation: gql`mutation ($name: String!, $email: String!, $password: String!) {
        register(name: $name, email: $email, password: $password) {
          token
          expiredAt
          user {
            role
          }
        }
      }`,
      variables: { name, email, password }
    })

    commit('login', res.data.register)
    this.$apolloHelpers.reset()
  }
}
