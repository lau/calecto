defmodule Calecto.Date do
  require Calendar.Date
  import Calecto.Utils

  @moduledoc """
  Calendar Date for Ecto
  """
  @behaviour Ecto.Type

  @doc """
  The Ecto primitive type.
  """
  def type, do: :date

  @doc """
  Casts to date.
  """
  def cast(<<year::4-bytes, ?-, month::2-bytes, ?-, day::2-bytes>>),
    do: from_parts(to_i(year), to_i(month), to_i(day))
  def cast(%Date{} = d),
    do: {:ok, d}
  def cast(%{"year" => year, "month" => month, "day" => day}),
    do: from_parts(to_i(year), to_i(month), to_i(day))
  def cast({year, month, day}),
    do: from_parts(to_i(year), to_i(month), to_i(day))
  def cast(_),
    do: :error

  def cast!(date) do
    {:ok, d} = cast(date)
    d
  end

  defp from_parts(year, month, day) when is_date(year, month, day) do
    Calendar.Date.from_erl({year, month, day})
  end

  defp from_parts(_, _, _), do: :error

  def from_erl({_year, _month, _day} = date_tuple) do
    date_tuple |> load
  end


  @doc """
  Converts to erlang style triplet
  """
  def dump(%Date{} = date) do
    {:ok, Calendar.Date.to_erl(date)}
  end

  @doc """
  Converts erlang style triplet to `Calendar.Date`
  """
  def load({year, month, day}) do
    Calendar.Date.from_erl({year, month, day})
  end
end
