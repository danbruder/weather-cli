defmodule Weather.MixProject do
  use Mix.Project

  def project do
    [
      app: :weather,
      escript: escript_config(),
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:httpoison, "~> 0.13.0"},
      {:sweet_xml, "~> 0.6.5"}
    ]
  end

  defp escript_config do
    [
      main_module: Weather.Cli
    ]
  end
end
