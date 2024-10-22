defmodule TodoApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :todo_app,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :dev,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TodoApp.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.5"},
      {:poison, "~> 3.1"},
      {:cors_plug, "~> 3.0"},
      {:jason, "~> 1.4"},
      {:myxql, "~> 0.6.0"},
       # test
      {:mock, "~> 0.3", only: :test}
    ]
  end
end
