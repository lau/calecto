defmodule Kalecto.Model do
  @doc false
  defmacro __using__(_opts) do
    quote do
      @timestamps_type Kalecto.DateTimeUTC
    end
  end
end
