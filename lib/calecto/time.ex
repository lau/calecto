defmodule Calecto.Time do
  require Calendar.Time
  import Calecto.Utils

  @moduledoc """
  Calendar Time for Ecto
  """

  defstruct [:hour, :min, :sec, :usec]

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
  def cast(%Calecto.Time{hour: h, min: m, sec: s, usec: u}),
    do: from_micro_erl({h,m,s,u})
  def cast(%Calendar.Time{} = t),
    do: {:ok, t}
  def cast(%{"hour" => hour, "min" => min, "sec" => sec}),
    do: from_parts(to_i(hour), to_i(min), to_i(sec))
  def cast(%{"hour" => hour, "min" => min}),
    do: from_parts(to_i(hour), to_i(min), 0)
  def cast({hour, min, sec}),
    do: from_parts(to_i(hour), to_i(min), to_i(sec))
  def cast({hour, min, sec, usec}),
    do: from_parts(to_i(hour), to_i(min), to_i(sec), to_i(usec))
  def cast(_),
    do: :error

  def cast!(time) do
    {:ok, t} = cast(time)
    t
  end

  defp from_parts(hour, min, sec) do
    from_erl({hour, min, sec})
  end
  defp from_parts(hour, min, sec, usec) do
    from_micro_erl({hour, min, sec, usec})
  end

  def from_micro_erl({hour, min, sec, usec}) do
    Calendar.Time.from_erl({hour, min, sec}, usec)
  end
  def from_erl({hour, min, sec}) do
    from_micro_erl({hour, min, sec, nil})
  end

  def to_micro_erl(%Calendar.Time{} = time) do
    IO.puts :stderr, "Warning: Calecto.Time.to_micro_erl is deprecated." <>
                     "Use Calendar.Time.to_micro_erl instead. " <>
                      Exception.format_stacktrace()
    Calendar.Time.to_micro_erl(time)
  end
  def to_micro_erl(%Calecto.Time{hour: h, min: m, sec: s, usec: nil}) do
    IO.puts :stderr, "Warning: the Calecto.Time struct is deprecated." <>
                     "Use Calendar.Time struct instead. " <>
                      Exception.format_stacktrace()
    {h, m, s, 0}
  end
  def to_micro_erl(%Calecto.Time{hour: h, min: m, sec: s, usec: u}) do
    IO.puts :stderr, "Warning: the Calecto.Time struct is deprecated." <>
                     "Use Calendar.Time struct instead. " <>
                      Exception.format_stacktrace()
    {h, m, s, u}
  end

  @doc """
  Converts a `Calendar.Time` into a time tuple.
  """
  def dump(%Calendar.Time{} = time) do
    {:ok, Calendar.Time.to_micro_erl(time)}
  end
  def dump(%Calecto.Time{usec: 0} = time) do
      IO.puts :stderr, "Warning: to_erl on Calecto.Time structs are deprecated." <>
                       "Use Calendar.Time structs instead. " <>
                        Exception.format_stacktrace()
    {:ok, {time.hour, time.min, time.sec, 0}}
  end
  def dump(%Calecto.Time{} = time) do
      IO.puts :stderr, "Warning: to_erl on Calecto.Time structs are deprecated." <>
                       "Use Calendar.Time structs instead. " <>
                        Exception.format_stacktrace()
    {:ok, to_micro_erl(time)}
  end

  @doc """
  Converts a time tuple into a `Calendar.Time`.
  """
  def load({hour, min, sec}) do
    Calendar.Time.from_erl({hour, min, sec})
  end

  def load({hour, min, sec, usec}) do
    Calendar.Time.from_erl({hour, min, sec}, usec)
  end
end

defimpl Calendar.ContainsTime, for: Calecto.Time do
  def time_struct(data) do
    IO.puts :stderr, "Warning: the Calecto.Time struct is deprecated." <>
                     "Use Calendar.Time instead. " <>
                      Exception.format_stacktrace()
    Calendar.Time.from_erl! {data.hour, data.min, data.sec}, data.usec
  end
end
