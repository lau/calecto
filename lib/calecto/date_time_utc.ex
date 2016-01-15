defmodule Calecto.DateTimeUTC do
  require Calendar.DateTime
  import Calecto.Utils

  @moduledoc """
  Calendar DateTime for Ecto for representing only UTC datetimes
  """

  @behaviour Ecto.Type

  defstruct [:year, :month, :day, :hour, :min, :sec, :usec, :timezone, :abbr, :utc_off, :std_off]

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

  def cast(%Calecto.DateTimeUTC{timezone: "Etc/UTC"} = dt),
    do: {:ok, dt}
  def cast(%Calendar.DateTime{timezone: "Etc/UTC"} = dt) do
    {tag, calecto_dt} = from_parts(dt.year, dt.month, dt.day, dt.hour, dt.min, dt.sec, dt.usec)
    case tag do
      :ok -> {:ok, calecto_dt}
      _ -> :error
    end
  end
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min, "sec"=>sec, "usec" => usec}) do
    from_erl({{to_i(year), to_i(month), to_i(day)},
      {to_i(hour), to_i(min), to_i(sec), to_i(usec)}})
  end
  def cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min, "sec"=>sec}) do
    cast(%{"year"=>year, "month"=>month, "day"=>day, "hour"=>hour, "min"=>min, "sec"=> sec, "usec" => 0})
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

  def to_micro_erl(%Calecto.DateTimeUTC{timezone: "Etc/UTC", year: year, month: month, day: day, hour: hour, min: min, sec: sec, usec: usec}) do
    {{year, month, day}, {hour, min, sec, usec}}
  end

  def to_calendar_date_time(%Calecto.DateTimeUTC{} = calecto_dt_utc) do
    {:ok, dt} = Calendar.DateTime.from_micro_erl_total_off(to_micro_erl(calecto_dt_utc), "Etc/UTC", 0)
    dt
  end

  @doc """
  Converts to erlang style tuples with microseconds added
  """
  def dump(%Calecto.DateTimeUTC{timezone: timezone}) when timezone != "Etc/UTC" do
    :error
  end
  def dump(%Calecto.DateTimeUTC{usec: nil} = dt) do
    {date_part, _time_part} = to_micro_erl(dt)
    {:ok, {date_part, {dt.hour, dt.min, dt.sec, 0}}}
  end
  def dump(%Calecto.DateTimeUTC{} = dt) do
    {:ok, to_micro_erl(dt) }
  end
  def dump(_), do: :error

  @doc """
  Converts erlang style tuples to `Calendar.DateTime`
  """
  def load({{year, month, day}, {hour, min, sec, usec}}) do
    { :ok,
      %Calecto.DateTimeUTC{year: year, month: month, day: day, hour: hour, min: min,
                      sec: sec, usec: usec, abbr: "UTC", timezone: "Etc/UTC",
                      utc_off: 0, std_off: 0}
    }
  end
  def load(_), do: :error
end
defimpl Calendar.ContainsDateTime, for: Calecto.DateTimeUTC do
  def dt_struct(data), do: Calecto.DateTimeUTC.to_calendar_date_time(data)
end
defimpl Calendar.ContainsNaiveDateTime, for: Calecto.DateTimeUTC do
  def ndt_struct(data) do
    {date, {h, m, s, u}} = data |> Calecto.DateTimeUTC.to_micro_erl
    Calendar.NaiveDateTime.from_erl!({date, {h,m,s}}, u)
  end
end
defimpl Calendar.ContainsDate, for: Calecto.DateTimeUTC do
  def date_struct(data) do
    {date, _} = data |> Calecto.DateTimeUTC.to_micro_erl
    Calendar.Date.from_erl! date
  end
end
defimpl Calendar.ContainsTime, for: Calecto.DateTimeUTC do
  def time_struct(data) do
    {_, {h, m, s, u}} = data |> Calecto.DateTimeUTC.to_micro_erl
    Calendar.Time.from_erl! {h, m, s}, u
  end
end
