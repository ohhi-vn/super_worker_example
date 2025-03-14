defmodule SuperWorkerExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :super_worker_example,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SuperWorkerExample.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:super_worker, "~> 0.0.4"}
    ]
  end
end
