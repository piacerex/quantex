defmodule Quantex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :quantex,
      version: "0.0.2",
      elixir: "~> 1.5",
      description: "Quantum computer system environment and libraries in Elixir", 
      package: 
      [
        maintainers: [ "piacere" ], 
        licenses:    [ "Apache 2.0" ], 
        links:       %{ "GitHub" => "https://github.com/piacere-ex/quantex" }, 
      ],
      start_permanent: Mix.env == :prod,
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
      { :ex_doc,         "~> 0.16",  only: :dev, runtime: false }, 
      { :power_assert,   "~> 0.1.1", only: :test }, 
      { :mix_test_watch, "~> 0.5",   only: :dev, runtime: false }, 
      { :numexy,         "~> 0.1.0" }, 
      { :math,           "~> 0.3.0" }, 
    ]
  end
end
