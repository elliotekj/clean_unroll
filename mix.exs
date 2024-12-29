defmodule CleanUnroll.MixProject do
  use Mix.Project

  @version "0.1.0"
  @repo_url "https://github.com/elliotekj/clean_unroll"

  def project do
    [
      app: :clean_unroll,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {CleanUnroll.Application, []}
    ]
  end

  defp deps do
    [
      {:finch, "~> 0.19"},
      {:ex_doc, "~> 0.36", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Elliot Jackson"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @repo_url}
    ]
  end

  defp description do
    """
    Unroll URLs and remove their tracking parameters
    """
  end

  defp docs do
    [
      name: "CleanUnroll",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/clean_unroll",
      source_url: @repo_url
    ]
  end
end
