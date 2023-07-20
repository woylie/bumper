# Bumper

Dirty little mix task that saves you 5 seconds of your time by bumping the
version of an Elixir project in `mix.exs`, `README.md` and `CHANGELOG.md` all
at once.

## Assumptions

- The version in `mix.exs` is assigned to a module attribute (e.g.
  `@version "0.1.0"`).
- `README.md` has installation instructions for adding the mix dependency
  (e.g. `{:my_library, "~> 0.1.0}`).
- The changelog uses the [keep a changelog](https://keepachangelog.com) format
  and has an `## Unreleased` header.

## Installation

Add `:bumper` as a mix dependency.

```elixir
def deps do
  [
    {:bumper, github: "woylie/bumper"}
  ]
end
```

## Usage

```bash
mix bump patch
mix bump minor
mix bump major
```

## Alternative

Use the fish function [bump.fish](https://github.com/woylie/bump.fish) to do the
same.
