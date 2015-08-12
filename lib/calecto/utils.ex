defmodule Calecto.Utils do
  @moduledoc false

  def usec("." <> string) do
    String.slice(string, 0..5)
    |> String.ljust(6, ?0)
    |> Integer.parse
    |> elem(0)
  end
  def usec(rest) when rest in ["", "Z"], do: 0
  def usec(_), do: nil

  def to_i(int) when is_integer(int) do
    int
  end

  def to_i(string) do
    {int, _} = Integer.parse(string)
    int
  end

  defmacro is_time(hour, min, sec, usec\\0) do
    quote do
      unquote(hour) in 0..23 and
      unquote(min) in 0..59 and
      unquote(sec) in 0..60 and
      unquote(usec) in 0..999_999
    end
  end

  # Date might be invalid. E.g. February 30th
  defmacro is_date(year, month, day) do
    quote do
      unquote(year) |> is_integer and
      unquote(month) in 0..12 and
      unquote(day) in 0..31
    end
  end
end
