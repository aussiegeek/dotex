defmodule Dotex.Mixfile do
  use Mix.Project

  def project do
    [app: :dotex,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package(),
     description: "Generate Graphviz graphs from Elixir",
     name: "Dotex",
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:temp, "~> 0.4"},
      {:credo, "~> 0.7", only: [:dev, :test]},
      {:ex_doc, "~> 0.14", only: :docs, runtime: false, optional: true},
      {:inch_ex, ">= 0.0.0", only: :docs, optional: true},
    ]
  end

  defp package do
    [
      name: :dotex,
      maintainers: ["Alan Harper"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/aussiegeek/dotex"}
    ]
  end
end
