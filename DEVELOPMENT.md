# Development

First off, this is a large complex project. It has three different languages and
uses different ways of communicating between them. This file will try to break
stuff down for you a bit more so you can contribute / understand what the hell
is going on.

## Running

Because this is such a huge project, there is a simple `docker-compose.yml` file
that will take care of everything you need.

To start, you will want to build the initial images. Don't worry, most of the
code is hot reloading, so you will not need to do this for every change. Only
if you are adding or removing packages.

Run these commands to get an environment up and running:

```sh
# Build the docker images
docker-compose build

# Setup the database
docker-compose run neon mix ecto.setup

# Import a bunch of stocks
docker-compose run neon mix service.alpaca_import
```

And finally, you should be able to start the app with `docker-compose up`.

It may take a bit to start up, but after a bit, you should be able to access
`localhost:4000` to see the site. Most modifications should update
automatically, so hack away!

**NOTE** You will need to click register to create a new account. You can then
run this command to make that account an admin:

```sh
docker-compose run neon mix account.promote_user email@example.com
```

## Languages

### Elixir

We use Elixir as the backbone to this app. It is responsible for the database
connection, serving web assets, scheduling cron jobs and a bunch of other
things.

### Javascript

This project services a fully static SPA written with Nuxt.JS. It is served as
raw files by the Elixir process and uses GraphQL to communicate. Everything is
found in the `lib/neon_client` directory.

### Rust

We use Rust for the heavy number crunching and machine learning parts. It is
talking to the Elixir process and is scheduled by the Elixir process's cron
management.

## Linting

This project has _a lot_ of linting to ensure everything works together. It all
runs on push and PR for this repo. If you want to run them manually, I would
take a look at the GitHub CI workflow for an up to date script.

## Commands

### Linting

There are a bunch of linting applications used for this project. Here is how to
run them, and other commands like auto fixing.

#### JavaScript

We use eslint to lint our client side application. This will also check all
GraphQL queries have the correct fields. Because of this, you will want to
ensure that the query file us up to date first with:

```sh
docker-compose run neon mix absinthe.schema.json ./priv/static/schema.json
```

Then run the lint command with:

```sh
docker-compose run neon npm run lint:js
```

To auto fix:

```sh
docker-compose run neon npm run lint:js -- --fix
```

### Stylesheets

We use stylelint to ensure our CSS is consistent throughout the application.

```sh
docker-compose run neon npm run lint:css
```

### Testing

We use Elixir's ExUnit test suite for _all_ testing, even the JavaScript. All
of the needed dependencies are wrapped up in the `docker-compose.yml` file,
so all you need to do is run the command for the test you want to run.

```sh
docker-compose run neon mix test.unit
```

In order to run the browser tests, you will need to generate the frontend SPA
app first.

```sh
docker-compose run neon npm run build
docker-compose run neon mix test.browser
```
