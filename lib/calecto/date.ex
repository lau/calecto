defmodule Calecto.Date do
  require Calendar.Date
  import Calecto.Utils

  @moduledoc """
  Calendar Date for Ecto
  """

  # this struct is deprecated
  defstruct [:year, :month, :day]

  @behaviour Ecto.Type

  @doc """
  The Ecto primitive type.
  """
  def type, do: :date

  @doc """
  Dates are blank when given as strings and the string is blank.
  """
  defdelegate blank?(value), to: Ecto.Type

  @doc """
  Casts to date.
  """
  def cast(<<year::4-bytes, ?-, month::2-bytes, ?-, day::2-bytes>>),
    do: from_parts(to_i(year), to_i(month), to_i(day))
  def cast(%Calendar.Date{} = d),
    do: {:ok, d}
  def cast(%Calecto.Date{year: y, month: m, day: d}),
    do: load({y, m, d})
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
  def dump(%Calendar.Date{} = date) do
    {:ok, Calendar.Date.to_erl(date)}
  end
  def dump(%Calecto.Date{} = date) do
    {:ok, to_erl(date)}
  end

  @doc """
  Converts erlang style triplet to `Calendar.Date`
  """
  def load({year, month, day}) do
    Calendar.Date.from_erl({year, month, day})
  end

  # Deprecated functions:
  def to_erl(%Calecto.Date{year: year, month: month, day: day}) do
      IO.puts :stderr, "Warning: to_erl on Calecto.Date is deprecated." <>
                       "Use Calendar.Date.to_erl instead. " <>
                        Exception.format_stacktrace()
    {year, month, day}
  end
  def to_erl(%Calendar.Date{year: year, month: month, day: day}) do
      IO.puts :stderr, "Warning: to_erl on Calecto.Date is deprecated." <>
                       "Use Calendar.Date.to_erl instead. " <>
                        Exception.format_stacktrace()
    {year, month, day}
  end
end
defimpl Calendar.ContainsDate, for: Calecto.Date do
  def date_struct(data) do
    IO.puts :stderr, "Warning: the Calecto.Date struct is deprecated." <>
                     "Use Calendar.Date instead. " <>
                      Exception.format_stacktrace()
    {data.year, data.month, data.day} |> Calendar.Date.from_erl!
  end
end
