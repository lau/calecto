defmodule Calecto.Mixfile do
  use Mix.Project

  def project do
    [app: :calecto,
     version: "0.17.0",
     elixir: "~> 1.3",
     package: package(),
     description: description(),
     deps: deps()]
  end

  def application do
    [applications: [:calendar]]
  end

  defp deps do
    [
      {:ecto, "~> 3.0"},
      {:calendar, "~> 0.16 or ~> 1.0"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  defp package do
    %{
       maintainers: ["Lau Taarnskov"],
       links: %{ "GitHub" => "https://github.com/lau/calecto"},
       licenses: ["MIT"],
       files: ~w(lib priv mix.exs README*
                    LICENSE CHANGELOG*) }
  end

  defp description do
    """
    Library for using Calendar with Ecto.
    Made for Ecto version older than 2.1.
    This lets you save Calendar types in Ecto and work
    with date-times in multiple timezones.
    """
  end
end
