# Development

First off, this is a large complex project. It has three different languages and
uses different ways of communicating between them. This file will try to break
stuff down for you a bit more so you can contribute / understand what the hell
is going on.

## Running

Because this is such a huge project, there is a simple `docker-compose.yml` file
that will take care of everything you need. Simply run `docker-compose up` and
access `localhost:4000` for a working environment. This also sets up hot code
reloading for most of the project (Elixir and JavaScript).

## Languages

### Elixir

We use Elixir as the backbone to this app. It is responsible for the database
connection, serving web assets, scheduling cron jobs and a bunch of other
things.

### Javascript

This project services a fully static SPA written with Nuxt.JS. It is served as
raw files by the Elixir process and uses GraphQL to communicate. Everything is
found in the `assets` directory.

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

```sh
docker-compose run neon mix test.browser
```
