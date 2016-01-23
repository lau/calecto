defimpl Ecto.DataType, for: Calendar.Date do
  def cast(%Calendar.Date{day: day, month: month, year: year}, type) when type in [:date, Calecto.Date, Ecto.Date] do
    {:ok, {year, month, day}}
  end
  def cast(_, _) do
    :error
  end
end
defimpl Ecto.DataType, for: Calendar.Time do
  def cast(%Calendar.Time{} = time, type) when type in [:date, Calecto.Time, Ecto.Time] do
    {:ok, Calendar.Time.to_micro_erl(time)}
  end
  def cast(_, _) do
    :error
  end
end
defimpl Ecto.DataType, for: Calendar.NaiveDateTime do
  def cast(%Calendar.NaiveDateTime{} = ndt, type) when type in [:datetime, Calecto.NaiveDateTime, Ecto.DateTime] do
    {:ok, Calendar.NaiveDateTime.to_micro_erl(ndt)}
  end
  def cast(_, _) do
    :error
  end
end
defimpl Ecto.DataType, for: Calendar.DateTime do
  def cast(%Calendar.DateTime{} = dt, type) when type in [:datetime, Calecto.NaiveDateTime, Calecto.DateTimeUTC, Ecto.DateTime] do
    {:ok, Calendar.NaiveDateTime.to_micro_erl(dt)}
  end
  def cast(_, _) do
    :error
  end
end
