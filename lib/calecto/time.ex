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
  def cast(%Calendar.Time{hour: h, min: m, sec: s, usec: u}),
    do: from_micro_erl({h,m,s,u})
  def cast(%Calecto.Time{} = t),
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

  defp from_parts(hour, min, sec) do
    from_erl({hour, min, sec})
  end
  defp from_parts(hour, min, sec, usec) do
    from_micro_erl({hour, min, sec, usec})
  end

  def from_micro_erl({hour, min, sec, usec}) do
    {tag, cal_time} = Calendar.Time.from_erl({hour, min, sec}, usec)
    case tag do
      :ok -> {:ok, %Calecto.Time{hour: cal_time.hour,
                          min: cal_time.min,
                          sec: cal_time.sec,
                          usec: cal_time.usec}}
      _ -> {:error, :invalid_time}
    end
  end
  def from_erl({hour, min, sec}) do
    from_micro_erl({hour, min, sec, nil})
  end

  def to_micro_erl(%Calecto.Time{hour: h, min: m, sec: s, usec: nil}) do
    {h, m, s, 0}
  end
  def to_micro_erl(%Calecto.Time{hour: h, min: m, sec: s, usec: u}) do
    {h, m, s, u}
  end

  @doc """
  Converts an `Ecto.Time` into a time tuple.
  """
  def dump(%Calecto.Time{usec: 0} = time) do
    {:ok, {time.hour, time.min, time.sec, 0}}
  end
  def dump(%Calecto.Time{} = time) do
    {:ok, to_micro_erl(time)}
  end

  @doc """
  Converts a time tuple into an `Ecto.Time`.
  """
  def load({hour, min, sec}) do
    from_erl({hour, min, sec})
  end

  def load({hour, min, sec, usec}) do
    from_micro_erl({hour, min, sec, usec})
  end
end

defimpl Calendar.ContainsTime, for: Calecto.Time do
  def time_struct(data) do
    Calendar.Time.from_erl! {data.hour, data.min, data.sec}, data.usec
  end
end
