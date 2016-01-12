defmodule Calecto.NaiveDateTime do
  require Calendar.NaiveDateTime
  import Calecto.Utils

  @moduledoc """
  Calendar NaiveDateTime for Ecto
  """
  defstruct [:year, :month, :day, :hour, :min, :sec, :usec]

  @behaviour Ecto.Type

  @doc """
  The Ecto primitive type.
  """
  def type, do: :datetime

  @doc """
  Datetimes are blank when given as strings and the string is blank.
  """
  defdelegate blank?(value), to: Ecto.Type

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
  def cast(%Calecto.NaiveDateTime{} = ndt),
    do: {:ok, ndt}
  def cast(%Calendar.NaiveDateTime{} = ndt) do
    {:ok, %Calecto.NaiveDateTime{year: ndt.year, month: ndt.month, day: ndt.day,
       hour: ndt.hour, min: ndt.min, sec: ndt.sec, usec: ndt.usec}}
  end
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min, "sec"=>sec, "usec" => usec}) do
    from_parts(to_i(year), to_i(month), to_i(day),
               to_i(hour), to_i(min), to_i(sec), to_i(usec))
  end
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min, "sec"=>sec}) do
    cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min, "sec"=> sec, "usec" => 0})
  end
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min}) do
    cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min, "sec"=> 0})
  end
  def cast(_),
    do: :error

  defp from_parts(year, month, day, hour, min, sec, usec) do
    load({{year, month, day},{hour, min, sec, usec}})
  end

  @doc """
  Converts to erlang style tuples
  """
  def dump(%Calecto.NaiveDateTime{} = dt) do
    {:ok, to_micro_erl(dt)}
  end

  def to_micro_erl(%Calecto.NaiveDateTime{} = dt) do
    {{dt.year, dt.month, dt.day}, {dt.hour, dt.min, dt.sec, dt.usec}}
  end

  def from_erl({{year, month, date}, {hour, min, sec}}) do
    from_erl({{year, month, date}, {hour, min, sec, 0}})
  end
  def from_erl({date, {hour, min, sec, usec}}) do
    {tag, ndt} = Calendar.NaiveDateTime.from_erl({date, {hour, min, sec}}, usec)
    case tag do
      :ok -> {:ok, %Calecto.NaiveDateTime{year: ndt.year, month: ndt.month, day: ndt.day,
         hour: ndt.hour, min: ndt.min, sec: ndt.sec, usec: ndt.usec}}
      _ -> {tag, ndt}
    end
  end

  def from_erl!(tuple) do
    {:ok, ndt} = from_erl(tuple)
    ndt
  end

  @doc """
  Converts erlang style tuples to `Calecto.NaiveDateTime`
  """
  def load({{year, month, day}, {hour, min, sec, usec}}) do
    {:ok, %Calecto.NaiveDateTime{year: year, month: month, day: day, hour: hour,
      min: min, sec: sec, usec: usec} }
  end
end

defimpl Calendar.ContainsNaiveDateTime, for: Calecto.NaiveDateTime do
  def ndt_struct(data) do
    {date, {h, m, s, u}} = data |> Calecto.NaiveDateTime.to_micro_erl
    Calendar.NaiveDateTime.from_erl!({date, {h,m,s}}, u)
  end
end
defimpl Calendar.ContainsDate, for: Calecto.NaiveDateTime do
  def date_struct(data) do
    {date, _} = data |> Calecto.NaiveDateTime.to_micro_erl
    Calendar.Date.from_erl! date
  end
end
defimpl Calendar.ContainsTime, for: Calecto.NaiveDateTime do
  def time_struct(data) do
    {_, {h, m, s, u}} = data |> Calecto.NaiveDateTime.to_micro_erl
    Calendar.Time.from_erl! {h, m, s}, u
  end
end
