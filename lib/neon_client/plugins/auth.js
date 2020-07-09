function routeOption (route, key, value) {
  return route.matched.some((m) => {
    return Object.values(m.components).some((component) => {
      return (component.options && component.options[key] === value)
    })
  })
}

function getMatchedComponents (route, matches = []) {
  return [].concat.apply([], route.matched.map(function (m, index) {
    return Object.keys(m.components).map(function (key) {
      matches.push(index)
      return m.components[key]
    })
  }))
}

export default (ctx) => {
  const { getters } = ctx.store

  ctx.app.router.beforeResolve((to, from, next) => {
    switch (true) {
      // auth disabled or no page found
      case (routeOption(to, 'auth', false)):
      case (getMatchedComponents(to, []).length < 1):
        return next()

      // auth required but not logged in
      case (routeOption(to, 'auth', 'admin') && !getters['auth/isLoggedIn']):
      case (routeOption(to, 'auth', 'user') && !getters['auth/isLoggedIn']):
        return next({ path: '/auth/login', replace: true })

      // not authorized for page
      case (routeOption(to, 'auth', 'admin') && !getters['auth/isAdmin']):
      case (routeOption(to, 'auth', 'user') && !getters['auth/isUser']):
        return next({ path: '/auth/unauthorized', replace: true })

      // guest only pages (like login and register)
      case (routeOption(to, 'auth', 'guest') && getters['auth/isLoggedIn']):
        return next({ path: '/dashboard', replace: true })

      default:
        return next()
    }
  })
}
