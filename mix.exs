defmodule Pg2.Mixfile do
  use Mix.Project

  def project do
    [
      app: :pg2_wrap,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      preferred_cli_env: [espec: :test],
    ]
  end

  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:espec, "~> 1.4.6", only: :test},
    ]
  end
end
