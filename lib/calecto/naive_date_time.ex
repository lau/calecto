defmodule Calecto.NaiveDateTime do
  require Calendar.NaiveDateTime
  import Calecto.Utils

  @moduledoc """
  Calendar NaiveDateTime for Ecto
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
  def cast(%NaiveDateTime{} = ndt),
    do: {:ok, ndt}
  def cast(%DateTime{} = dt),
    do: {:ok, dt |> Calendar.DateTime.to_naive}
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "minute"=>min, "second"=>sec, "microsecond" => usec}) do
    from_parts(to_i(year), to_i(month), to_i(day),
               to_i(hour), to_i(min), to_i(sec), to_i(usec))
  end
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min, "sec"=>sec, "usec" => usec}) do
    from_parts(to_i(year), to_i(month), to_i(day),
               to_i(hour), to_i(min), to_i(sec), to_i(usec))
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

  @doc """
  Converts to erlang style tuples
  """
  def dump(%NaiveDateTime{} = dt) do
    {:ok, Calendar.NaiveDateTime.to_micro_erl(dt)}
  end

  def from_erl({{year, month, date}, {hour, min, sec}}) do
    from_erl({{year, month, date}, {hour, min, sec, 0}})
  end
  def from_erl({date, {hour, min, sec, usec}}) do
    Calendar.NaiveDateTime.from_erl({date, {hour, min, sec}}, usec)
  end

  def from_erl!(tuple) do
    {:ok, ndt} = from_erl(tuple)
    ndt
  end

  @doc """
  Converts erlang style tuples to `Calendar.NaiveDateTime`
  """
  def load({date, {hour, min, sec, usec}}) do
    {date, {hour, min, sec}} |> Calendar.NaiveDateTime.from_erl(usec)
  end
end
