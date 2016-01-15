defmodule Calecto.Date do
  require Calendar.Date
  import Calecto.Utils

  @moduledoc """
  Calendar Date for Ecto
  """

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
  def cast(%Calecto.Date{} = d),
    do: {:ok, d}
  def cast(%Calendar.Date{year: y, month: m, day: d}),
    do: from_erl({y, m, d})
  def cast(%{"year" => year, "month" => month, "day" => day}),
    do: from_parts(to_i(year), to_i(month), to_i(day))
  def cast({year, month, day}),
    do: from_parts(to_i(year), to_i(month), to_i(day))
  def cast(_),
    do: :error

  def cast!(date) do
    {:ok, d} = date
    d
  end

  defp from_parts(year, month, day) when is_date(year, month, day) do
    from_erl({year, month, day})
  end

  defp from_parts(_, _, _), do: :error

  def from_erl({_year, _month, _day} = date_tuple) do
    {tag, calendar_date} = date_tuple |> Calendar.Date.from_erl
    case tag do
      :ok -> {:ok, %Calecto.Date{year: calendar_date.year,
                    month: calendar_date.month,
                    day: calendar_date.day} }
      _ -> {:error, :invalid_date}
    end
  end

  def to_erl(%Calecto.Date{year: year, month: month, day: day}) do
    {year, month, day}
  end

  @doc """
  Converts to erlang style triplet
  """
  def dump(%Calecto.Date{} = date) do
    {:ok, to_erl(date)}
  end

  @doc """
  Converts erlang style triplet to `Calendar.Date`
  """
  def load({year, month, day}) do
    from_erl({year, month, day})
  end
end
defimpl Calendar.ContainsDate, for: Calecto.Date do
  def date_struct(data) do
    {data.year, data.month, data.day} |> Calendar.Date.from_erl!
  end
end
