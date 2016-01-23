defmodule Calecto.Model do
  @moduledoc """
  This module name is deprecated in favor of `Calecto.Schema`
  Simply use the model name `Calecto.Schema` instead of `Calecto.Model`.

  See docs for `Calecto.Schema`
  """
  @default_timestamps_opts [type: Calecto.DateTimeUTC]
  defmacro __using__(opts) do
    quote do
      @timestamps_opts unquote(Dict.merge(opts, @default_timestamps_opts))
    end
  end
end
