defmodule Calecto.NaiveDateTime do
  require Calendar.NaiveDateTime
  import Ecto.DateTime.Util

  @moduledoc """
  Calendar NaiveDateTime for Ecto
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
  def cast(%Calendar.NaiveDateTime{} = ndt),
    do: {:ok, ndt}
  def cast(_),
    do: :error

  defp from_parts(year, month, day, hour, min, sec, usec) do
    load({{year, month, day},{hour, min, sec, usec}})
  end

  @doc """
  Converts to erlang style tuples
  """
  def dump(%Calendar.NaiveDateTime{} = dt) do
    {:ok, Calendar.NaiveDateTime.to_micro_erl(dt)}
  end

  @doc """
  Converts erlang style tuples to `Calendar.NaiveDateTime`
  """
  def load({{year, month, day}, {hour, min, sec, usec}}) do
    Calendar.NaiveDateTime.from_erl({{year, month, day}, {hour, min, sec}}, usec)
  end
end
