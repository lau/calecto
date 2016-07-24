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
  Cast DateTime
  """
  def cast(%DateTime{} = dt), do: {:ok, dt}
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "minute"=>min,
             "second"=>sec, "microsecond" => usec, "time_zone" => timezone}) do
    Calendar.DateTime.from_erl({{to_i(year), to_i(month), to_i(day)},
      {to_i(hour), to_i(min), to_i(sec)}}, timezone, to_i(usec))
  end
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min, # legacy
             "sec"=>sec, "usec" => usec, "timezone" => timezone}) do
    Calendar.DateTime.from_erl({{to_i(year), to_i(month), to_i(day)},
      {to_i(hour), to_i(min), to_i(sec)}}, timezone, to_i(usec))
  end
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "minute"=>min,
             "second"=>sec, "time_zone" => timezone}) do
    cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min,
           "sec"=> sec, "usec" => 0, "timezone" => timezone})
  end
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min, # legacy
             "sec"=>sec, "timezone" => timezone}) do
    cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min,
           "sec"=> sec, "usec" => 0, "timezone" => timezone})
  end
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "minute"=>min,
             "time_zone" => timezone}) do
    cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min,
           "sec"=> 0, "timezone" => timezone})
  end
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min, # legacy
             "timezone" => timezone}) do
    cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min,
           "sec"=> 0, "timezone" => timezone})
  end

  def cast!(datetime) do
    {:ok, dt} = cast(datetime)
    dt
  end

  @doc """
  Converts to a tuple of:
    - erlang style tuples with microseconds added
    - total_offset in seconds
    - timezone
  """
  def dump(%DateTime{} = dt) do
    {:ok, {Calendar.DateTime.to_micro_erl(dt), dt.utc_offset+dt.std_offset, dt.time_zone}}
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
