defmodule Calecto.Mixfile do
  use Mix.Project

  def project do
    [app: :calecto,
     version: "0.6.0",
     elixir: "~> 1.1",
     package: package,
     description: description,
     deps: deps]
  end

  def application do
    [applications: [:logger, :calendar]]
  end

  defp deps do
    [
      {:ecto, "~> 1.1.3 or ~> 2.0.0 or ~> 2.0.0-rc3"},
      {:calendar, "~> 0.14.1"},

      {:earmark, "~> 0.2.1", only: :dev},
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
