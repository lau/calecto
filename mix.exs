defmodule Kalecto.Mixfile do
  use Mix.Project

  def project do
    [app: :kalecto,
     version: "0.2.2",
     elixir: "~> 1.0",
     package: package,
     description: description,
     deps: deps]
  end

  def application do
    [applications: [:logger, :kalends]]
  end

  defp deps do
    [
      {:ecto, "~> 0.9.0 or ~> 0.10.1"},
      {:kalends, "~> 0.6.2"},

      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.7", only: :dev},
    ]
  end

  defp package do
    %{
       contributors: ["Lau Taarnskov"],
       links: %{ "GitHub" => "https://github.com/lau/kalecto"},
       files: ~w(lib priv mix.exs README* LICENSE*
                    license* CHANGELOG* changelog* src) }
  end

  defp description do
    """
    Library for using Kalends with Ecto.
    This lets you save Kalends types in Ecto and work
    with date-times in multiple timezones.
    """
  end
end
