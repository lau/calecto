defmodule Calecto.Model do
  @moduledoc """
  This module name is deprecated in favor of `Calecto.Schema`
  Simply use the model name `Calecto.Schema` instead of `Calecto.Model`.

  See docs for `Calecto.Schema`
  """
  @default_timestamps_opts [type: Calecto.DateTimeUTC]
  defmacro __using__(opts) do
    autogen_args = case Keyword.fetch(opts, :usec) do
      {:ok, true} -> [:usec]
      _           -> [:sec]
    end
    autogenerate_opts = [autogenerate: {Calecto.DateTimeUTC, :autogenerate, autogen_args}]
    escaped_opts = opts |> Dict.merge(autogenerate_opts) |> Macro.escape
    quote do
      @timestamps_opts unquote(Dict.merge(escaped_opts, @default_timestamps_opts))
      IO.puts "!!!!!!!!!!"
      IO.puts "Don't use Calecto.Model. It has been deprecated. Change your code to use Calecto.Schema instead."
      IO.puts "!!!!!!!!!!"
    end
  end
end
