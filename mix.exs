defmodule Calecto.Mixfile do
  use Mix.Project

  def project do
    [app: :calecto,
     version: "0.4.4",
     elixir: "~> 1.0",
     package: package,
     description: description,
     deps: deps]
  end

  def application do
    [applications: [:logger, :calendar]]
  end

  defp deps do
    [
      {:ecto, "~> 0.15 or ~> 1.0"},
      {:calendar, "~> 0.12.0 or ~> 0.11.1 or ~> 0.10.1"},

      {:earmark, "~> 0.2", only: :dev},
      {:ex_doc, "~> 0.11.3", only: :dev},
    ]
  end

  defp package do
    %{
       maintainers: ["Lau Taarnskov"],
       links: %{ "GitHub" => "https://github.com/lau/calecto"},
       files: ~w(lib priv mix.exs README* LICENSE*
                    license* CHANGELOG* changelog* src) }
  end

  defp description do
    """
    Library for using Calendar with Ecto.
    This lets you save Calendar types in Ecto and work
    with date-times in multiple timezones.
    """
  end
end
