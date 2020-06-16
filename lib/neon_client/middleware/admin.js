import gql from 'graphql-tag'

const USER_QUERY = gql`
query {
  profile{
    name
  }
}
`

export default async function adminMiddleware ({ app, redirect }) {
  const apollo = app.apolloProvider.defaultClient
  const query = await apollo.query({ query: USER_QUERY })

  if (query.data.profile == null || query.data.profile.name == null) {
    return redirect('/auth/login')
  }
}
