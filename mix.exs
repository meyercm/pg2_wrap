defmodule Pg2.Mixfile do
  use Mix.Project

  @version "1.0.0"
  @repo_url "https://github.com/meyercm/pg2_wrap"
  def project do
    [
      app: :pg2_wrap,
      version: @version,
      elixir: "~> 1.0",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      # Hex
      package: hex_package(),
      description: "Elixir wrapper for `:pg2` with some conveniences",
      # Docs
      name: "Pg2",
      preferred_cli_env: [espec: :test],
    ]
  end

  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  defp hex_package do
    [maintainers: ["Chris Meyer"],
     licenses: ["MIT"],
     links: %{"GitHub" => @repo_url}]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:earmark, ">= 0.0.0", only: :dev},
      {:espec, "~> 1.4.6", only: :test},
    ]
  end
end
