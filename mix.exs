defmodule Kalecto.Mixfile do
  use Mix.Project

  def project do
    [app: :kalecto,
     version: "0.0.2",
     elixir: "~> 1.0",
     package: package,
     description: description,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :kalends]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:ecto, "~> 0.8.1"},
      {:kalends, "~> 0.4"},
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
