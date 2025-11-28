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
    dev_app =
      case Mix.env() do
        :dev -> [:observer, :wx]
        _ -> []
      end

    [
      extra_applications: [:logger] ++ dev_app,
      mod: {SuperWorkerExample.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      #  path: "../../super_worker"}
      {:super_worker, "~> 0.3.2"}
    ]
  end
end
