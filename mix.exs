defmodule Membrane.AAC.Format.MixProject do
  use Mix.Project

  @version "0.7.0"
  @github_url "https://github.com/membraneframework/membrane_aac_format"

  def project do
    [
      app: :membrane_aac_format,
      version: @version,
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      description: "Advanced Audio Codec Membrane format",
      package: package(),
      name: "Membrane AAC Format",
      source_url: @github_url,
      docs: docs(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: []
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp docs do
    [
      main: "readme",
      extras: ["README.md", "LICENSE"],
      source_ref: "v#{@version}"
    ]
  end

  defp package do
    [
      maintainers: ["Membrane Team"],
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @github_url,
        "Membrane Framework Homepage" => "https://membraneframework.org"
      }
    ]
  end

  defp deps do
    [
      {:bimap, "~> 1.1"},
      {:ex_doc, "~> 0.21", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
