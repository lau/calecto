defimpl Calendar.ContainsNaiveDateTime, for: Ecto.DateTime do
  def ndt_struct(data) do
    {{year, month, day}, {hour, min, sec}} = data |> Ecto.DateTime.to_erl
    Calendar.NaiveDateTime.from_erl!({{year, month, day}, {hour, min, sec}}, data.usec)
  end
end
defimpl Calendar.ContainsDate, for: Ecto.DateTime do
  def date_struct(data) do
    {{year, month, day}, _} = data |> Ecto.DateTime.to_erl
    Calendar.Date.from_erl!({year, month, day})
  end
end
defimpl Calendar.ContainsTime, for: Ecto.DateTime do
  def time_struct(data) do
    Calendar.Time.from_erl!({data.hour, data.min, data.sec}, data.usec)
  end
end
defimpl Calendar.ContainsDate, for: Ecto.Date do
  def date_struct(data) do
    Calendar.Date.from_erl!({data.year, data.month, data.day})
  end
end
defimpl Calendar.ContainsTime, for: Ecto.Time do
  def time_struct(data) do
    Calendar.Time.from_erl!({data.hour, data.min, data.sec}, data.usec)
  end
end
