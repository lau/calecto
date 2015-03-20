defmodule Kalecto.DateTime do
  require Kalends.DateTime

  @moduledoc """
  Kalends DateTime for Ecto for representing only UTC datetimes
  """

  @behaviour Ecto.Type

  @doc """
  The Ecto primitive type.
  """
  def type, do: :kalends_datetime

  @doc """
  Datetimes are blank when given as strings and the string is blank.
  """
  defdelegate blank?(value), to: Ecto.Type

  @doc """
  Cast DateTime
  """
  def cast(%Kalends.DateTime{} = dt), do: {:ok, dt}

  @doc """
  Converts to a tuple of:
    - erlang style tuples with microseconds added
    - total_offset in seconds
    - timezone
  """
  def dump(%Kalends.DateTime{} = dt) do
    {:ok, {Kalends.DateTime.to_micro_erl(dt), dt.utc_off+dt.std_off, dt.timezone}}
  end

  def dump(_), do: :error

  @doc """
  Converts tuple to `Kalends.DateTime`

  Tuple should consist of:
    - erlang style tuples with microseconds added
    - total_offset in seconds
    - timezone
  """
  def load({dt, total_off, timezone}) do
    Kalends.DateTime.from_micro_erl_total_off(dt, timezone, total_off)
  end

  def load(_), do: :error
end
