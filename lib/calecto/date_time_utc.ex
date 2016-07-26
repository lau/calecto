defmodule Calecto.DateTimeUTC do
  require Calendar.DateTime
  import Calecto.Utils

  @moduledoc """
  Calendar DateTime for Ecto for representing only UTC datetimes
  """

  @behaviour Ecto.Type

  @doc """
  The Ecto primitive type.
  """
  def type, do: :datetime

  @doc """
  Casts to datetime.
  """
  def cast(<<year::4-bytes, ?-, month::2-bytes, ?-, day::2-bytes, sep,
             hour::2-bytes, ?:, min::2-bytes, ?:, sec::2-bytes, rest::binary>>) when sep in [?\s, ?T] do
    if usec(rest) do
      from_parts(to_i(year), to_i(month), to_i(day),
                 to_i(hour), to_i(min), to_i(sec), usec(rest))
    else
      :error
    end
  end

  def cast(%DateTime{time_zone: "Etc/UTC"} = dt),
    do: {:ok, dt}
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "minute"=>min, "second"=>sec, "microsecond" => usec}) do
    from_erl({{to_i(year), to_i(month), to_i(day)},
      {to_i(hour), to_i(min), to_i(sec), to_i(usec)}})
  end
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min, "sec"=>sec, "usec" => usec}) do
    from_erl({{to_i(year), to_i(month), to_i(day)},
      {to_i(hour), to_i(min), to_i(sec), to_i(usec)}})
  end
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "minute"=>min, "second"=>sec}) do
    cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min, "sec"=> sec, "usec" => 0})
  end
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min, "sec"=>sec}) do
    cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min, "sec"=> sec, "usec" => 0})
  end
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "minute"=>min}) do
    cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min, "sec"=> 0})
  end
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min}) do
    cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min, "sec"=> 0})
  end
  def cast(_),
    do: :error

  def cast!(datetime) do
    {:ok, dt} = cast(datetime)
    dt
  end

  defp from_parts(year, month, day, hour, min, sec, usec) do
    load({{year, month, day},{hour, min, sec, usec}})
  end

  def from_erl({{year, month, day},{hour, min, sec, usec}}) do
    from_parts(year, month, day, hour, min, sec, usec)
  end
  def from_erl({{year, month, day},{hour, min, sec}}) do
    from_parts(year, month, day, hour, min, sec, nil)
  end

  def from_erl!(tuple) do
    {:ok, dt} = from_erl(tuple)
    dt
  end

  @doc """
  Converts to erlang style tuples with microseconds added
  """
  def dump(%DateTime{time_zone: "Etc/UTC"} = dt) do
    {:ok, Calendar.DateTime.to_micro_erl(dt) }
  end
  def dump(_), do: :error

  @doc """
  Converts erlang style tuples to `Calendar.DateTime`
  """
  def load({{year, month, day}, {hour, min, sec, usec}}) do
    { :ok,
      %DateTime{year: year, month: month, day: day, hour: hour, minute: min,
                      second: sec, microsecond: {usec, 6}, zone_abbr: "UTC", time_zone: "Etc/UTC",
                      utc_offset: 0, std_offset: 0}
    }
  end
  def load(_), do: :error

  @doc false
  def autogenerate(precision \\ :sec)
  def autogenerate(:sec) do
    {date, {h, m, s}} = :erlang.universaltime
    load({date, {h, m, s, 0}}) |> elem(1)
  end
  def autogenerate(:usec) do
    timestamp = {_, _, usec} = :os.timestamp
    {date, {h, m, s}} =:calendar.now_to_datetime(timestamp)
    load({date, {h, m, s, usec}}) |> elem(1)
  end
end
