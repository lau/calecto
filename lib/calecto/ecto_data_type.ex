defimpl Ecto.DataType, for: Calendar.Date do
  def dump(value), do: cast(value, :date)
  def cast(%Calendar.Date{day: day, month: month, year: year}, type) when type in [:date, Calecto.Date, Ecto.Date] do
    {:ok, {year, month, day}}
  end
  def cast(_, _) do
    :error
  end
end
defimpl Ecto.DataType, for: Calendar.Time do
  def dump(value), do: cast(value, :time)
  def cast(%Calendar.Time{} = time, type) when type in [:time, Calecto.Time, Ecto.Time] do
    {:ok, Calendar.Time.to_micro_erl(time)}
  end
  def cast(_, _) do
    :error
  end
end
defimpl Ecto.DataType, for: Calendar.NaiveDateTime do
  def dump(value), do: cast(value, :datetime)
  def cast(%Calendar.NaiveDateTime{} = ndt, type) when type in [:datetime, Calecto.NaiveDateTime, Ecto.DateTime] do
    {:ok, Calendar.NaiveDateTime.to_micro_erl(ndt)}
  end
  def cast(_, _) do
    :error
  end
end
defimpl Ecto.DataType, for: Calendar.DateTime do
  def dump(value), do: cast(value, :datetime)
  def cast(%Calendar.DateTime{} = dt, type) when type in [:datetime, Calecto.NaiveDateTime, Ecto.DateTime] do
    {:ok, Calendar.NaiveDateTime.to_micro_erl(dt)}
  end
  def cast(%Calendar.DateTime{timezone: "Etc/UTC"} = dt, Calecto.DateTimeUTC) do
    {:ok, Calendar.DateTime.to_micro_erl(dt)}
  end
  def cast(_, _) do
    :error
  end
end
