# CleanUnroll

[![Hex.pm Version](http://img.shields.io/hexpm/v/clean_unroll.svg?style=flat)](https://hex.pm/packages/clean_unroll)
[![Hex Docs](https://img.shields.io/badge/hex%20docs-blue)](https://hexdocs.pm/clean_unroll)
[![Hex.pm License](http://img.shields.io/hexpm/l/clean_unroll.svg?style=flat)](https://hex.pm/packages/clean_unroll)

**Unroll URLs and remove their tracking parameters**

## Installation

This package can be installed by adding `clean_unroll` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:clean_unroll, "~> 0.1"}
  ]
end
```

## Examples

```elixir
iex> CleanUnroll.clean_unroll("https://example.com/page?utm_source=twitter&id=123")
{:ok, "https://example.com/page?id=123"}

iex> CleanUnroll.clean_unroll("https://example.com/page?custom_param=value", ["custom_param"])
{:ok, "https://example.com/page"}

iex> CleanUnroll.clean("https://example.com/page?utm_source=twitter&id=123")
"https://example.com/page?id=123"

iex> CleanUnroll.unroll("https://t.co/shortened")
{:ok, "https://example.com/full-url"}
```

## License

`CleanUnroll` is released under the [`Apache License 2.0`](https://github.com/elliotekj/clean_unroll/blob/main/LICENSE).

## About

This package was written by [Elliot Jackson](https://elliotekj.com).

- Blog: [https://elliotekj.com](https://elliotekj.com)
- Email: elliot@elliotekj.com
