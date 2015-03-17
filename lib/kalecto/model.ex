defmodule Kalecto.Model do
  @doc false
  defmacro __using__(_opts) do
    quote do
      use Ecto.Model
      @timestamps_type Kalecto.DateTimeUTC
    end
  end
end
