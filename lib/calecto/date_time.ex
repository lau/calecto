defmodule Calecto.DateTime do
  require Calendar.DateTime
  import Calecto.Utils

  @moduledoc """
  Calendar DateTime for Ecto for representing datetimes in any timezone.

  This type is only compatible with Postgres.
  """

  @behaviour Ecto.Type

  @doc """
  The Ecto primitive type.
  """
  def type, do: :calendar_datetime

  @doc """
  Datetimes are blank when given as strings and the string is blank.
  """
  defdelegate blank?(value), to: Ecto.Type

  @doc """
  Cast DateTime
  """
  def cast(%Calendar.DateTime{} = dt), do: {:ok, dt}
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min,
             "sec"=>sec, "usec" => usec, "timezone" => timezone}) do
    Calendar.DateTime.from_erl({{to_i(year), to_i(month), to_i(day)},
      {to_i(hour), to_i(min), to_i(sec)}}, timezone, to_i(usec))
  end
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min,
             "sec"=>sec, "timezone" => timezone}) do
    cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min,
           "sec"=> sec, "usec" => 0, "timezone" => timezone})
  end
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min,
             "timezone" => timezone}) do
    cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min,
           "sec"=> 0, "timezone" => timezone})
  end

  def cast!(datetime) do
    {:ok, dt} = datetime
    dt
  end

  @doc """
  Converts to a tuple of:
    - erlang style tuples with microseconds added
    - total_offset in seconds
    - timezone
  """
  def dump(%Calendar.DateTime{} = dt) do
    {:ok, {Calendar.DateTime.to_micro_erl(dt), dt.utc_off+dt.std_off, dt.timezone}}
  end

  def dump(_), do: :error

  @doc """
  Converts tuple to `Calendar.DateTime`

  Tuple should consist of:
    - erlang style tuples with microseconds added
    - total_offset in seconds
    - timezone
  """
  def load({dt, total_off, timezone}) do
    Calendar.DateTime.from_micro_erl_total_off(dt, timezone, total_off)
  end

  def load(_), do: :error
end
