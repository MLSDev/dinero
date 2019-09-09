defmodule Dinero.MixProject do
  use Mix.Project

  @version "1.3.2"

  def project do
    [
      app: :dinero,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      description: description(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      package: package(),
      source_url: "https://github.com/MLSDev/dinero",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    "Elixir library for working with Money (slang Dinero)"
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/MLSDev/dinero"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:ecto, "~>3.0", optional: true},
      {:excoveralls, "~> 0.10", only: :test},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  def docs do
    [
      extras: [
        "README.md": [filename: "readme", title: "Readme"],
        "CHANGELOG.md": [filename: "changelog", title: "Changelog"],
      ],
      main: "readme",
      source_ref: "v#{@version}"
    ]
  end
end
