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
