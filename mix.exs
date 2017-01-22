defmodule Calecto.Mixfile do
  use Mix.Project

  def project do
    [app: :calecto,
     version: "0.16.2",
     elixir: "~> 1.3",
     package: package(),
     description: description(),
     deps: deps()]
  end

  def application do
    [applications: [:logger, :calendar]]
  end

  defp deps do
    [
      {:ecto, "~> 1.1.3 or ~> 2.0"},
      {:calendar, "~> 0.16"},

      {:ex_doc, "~> 0.14.5", only: :dev},
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
    This lets you save Calendar types in Ecto and work
    with date-times in multiple timezones.
    """
  end
end
