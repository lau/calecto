defimpl Ecto.DataType, for: Date do
  def dump(value), do: cast(value, :date)
  def cast(%Date{day: day, month: month, year: year}, type) when type in [:date, Calecto.Date, Ecto.Date] do
    {:ok, {year, month, day}}
  end
  def cast(_, _) do
    :error
  end
end
defimpl Ecto.DataType, for: Time do
  def dump(value), do: cast(value, :time)
  def cast(%Time{} = time, type) when type in [:time, Calecto.Time, Ecto.Time] do
    {:ok, Calendar.Time.to_micro_erl(time)}
  end
  def cast(_, _) do
    :error
  end
end
defimpl Ecto.DataType, for: NaiveDateTime do
  def dump(value), do: cast(value, :datetime)
  def cast(%NaiveDateTime{} = ndt, type) when type in [:datetime, Calecto.NaiveDateTime, Ecto.DateTime] do
    {:ok, Calendar.NaiveDateTime.to_micro_erl(ndt)}
  end
  def cast(_, _) do
    :error
  end
end
defimpl Ecto.DataType, for: DateTime do
  def dump(value), do: cast(value, :datetime)
  def cast(%DateTime{} = dt, type) when type in [:datetime, Calecto.NaiveDateTime, Ecto.DateTime] do
    {:ok, Calendar.NaiveDateTime.to_micro_erl(dt)}
  end
  def cast(%DateTime{time_zone: "Etc/UTC"} = dt, Calecto.DateTimeUTC) do
    {:ok, Calendar.DateTime.to_micro_erl(dt)}
  end
  def cast(_, _) do
    :error
  end
end
