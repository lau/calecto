defmodule Kalecto.Time do
  require Kalends.Time
  import Ecto.DateTime.Util

  @moduledoc """
  Kalends Time for Ecto
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
  def cast(<<hour::16, ?:, min::16, ?:, sec::16, rest::binary>>) do
    if valid_rest?(rest), do: from_parts(to_i(hour), to_i(min), to_i(sec)), else: :error
  end
  def cast(%Kalends.Time{} = t),
    do: {:ok, t}
  def cast(_),
    do: :error

  defp from_parts(hour, min, sec) do
    Kalends.Time.from_erl({hour, min, sec})
  end
  defp from_parts(_, _, _), do: :error

  @doc """
  Converts an `Ecto.Time` into a time triplet.
  """
  def dump(%Kalends.Time{} = time) do
    {:ok, Kalends.Time.to_erl(time)}
  end

  @doc """
  Converts a time triplet into an `Ecto.Time`.
  """
  def load({hour, min, sec}) do
    Kalends.Time.from_erl({hour, min, sec})
  end
end
