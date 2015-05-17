defmodule Kalecto.Model do
  @doc false
  @default_timestamps_opts [type: Kalecto.DateTimeUTC]
  defmacro __using__(opts) do
    quote do
      @timestamps_opts unquote(Dict.merge(opts, @default_timestamps_opts))
    end
  end
end
