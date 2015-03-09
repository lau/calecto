defmodule Kalecto.DateTimeUTC do
  require Kalends.DateTime
  import Ecto.DateTime.Util

  @moduledoc """
  Kalends DateTime for Ecto for representing only UTC datetimes
  """

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

  def cast(%Kalends.DateTime{timezone: "Etc/UTC"} = dt),
    do: {:ok, dt}
  def cast(_),
    do: :error

  defp from_parts(year, month, day, hour, min, sec, usec) do
    load({{year, month, day},{hour, min, sec, usec}})
  end

  @doc """
  Converts to erlang style tuples with microseconds added
  """
  def dump(%Kalends.DateTime{timezone: timezone}) when timezone != "Etc/UTC" do
    :error
  end
  def dump(%Kalends.DateTime{} = dt) do
    {:ok, Kalends.DateTime.to_micro_erl(dt) }
  end
  def dump(_), do: :error

  @doc """
  Converts erlang style tuples to `Kalends.DateTime`
  """
  def load({{year, month, day}, {hour, min, sec, usec}}) do
    { :ok,
      %Kalends.DateTime{year: year, month: month, day: day, hour: hour, min: min,
                      sec: sec, usec: usec, abbr: "UTC", timezone: "Etc/UTC",
                      utc_off: 0, std_off: 0}
    }
  end
  def load(_), do: :error
end
