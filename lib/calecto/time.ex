defmodule Calecto.Time do
  require Calendar.Time
  import Ecto.DateTime.Util

  @moduledoc """
  Calendar Time for Ecto
  """

  @behaviour Ecto.Type

  @doc """
  The Ecto primitive type.
  """
  def type, do: :time

  @doc """
  Times are blank when given as strings and the string is blank.
  """
  defdelegate blank?(value), to: Ecto.Type

  @doc """
  Casts to time.
  """
  def cast(<<hour::2-bytes, ?:, min::2-bytes, ?:, sec::2-bytes, rest::binary>>) do
    if usec(rest) do
      from_parts(to_i(hour), to_i(min), to_i(sec))
    else
      :error
    end
  end
  def cast(%Calendar.Time{} = t),
    do: {:ok, t}
  def cast(%{"hour" => hour, "min" => min, "sec" => sec}),
    do: from_parts(to_i(hour), to_i(min), to_i(sec))
  def cast(%{"hour" => hour, "min" => min}),
    do: from_parts(to_i(hour), to_i(min), to_i(0))
  def cast(_),
    do: :error

  defp from_parts(hour, min, sec) do
    Calendar.Time.from_erl({hour, min, sec})
  end

  @doc """
  Converts an `Ecto.Time` into a time triplet.
  """
  def dump(%Calendar.Time{} = time) do
    {:ok, Calendar.Time.to_erl(time)}
  end

  @doc """
  Converts a time triplet into an `Ecto.Time`.
  """
  def load({hour, min, sec}) do
    Calendar.Time.from_erl({hour, min, sec})
  end
end
