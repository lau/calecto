defmodule EctoDataTypesTest do
  require Ecto.DateTime
  use ExUnit.Case

  test "Ecto datatype dump for Calendar.Time" do
    assert Ecto.DataType.dump(%Calendar.Time{hour: 23, min: 50, sec: 50}) == {:ok, {23, 50, 50, 0}}
  end
  test "Ecto datatype dump for Calendar.Date" do
    assert Ecto.DataType.dump(%Calendar.Date{month: 12, day: 20, year: 2000}) == {:ok, {2000, 12, 20}}
  end
  test "Ecto datatype dump for Calendar.NaiveDateTime" do
    assert Ecto.DataType.dump(%Calendar.NaiveDateTime{hour: 23, min: 50, sec: 50, month: 12, day: 20, year: 2000}) == {:ok, {{2000, 12, 20}, {23, 50, 50, 0}}}
  end
  test "Ecto datatype dump for Calendar.DateTime" do
    assert Ecto.DataType.dump(%Calendar.DateTime{hour: 23, min: 50, sec: 50, month: 12, day: 20, year: 2000}) == {:ok, {{2000, 12, 20}, {23, 50, 50, 0}}}
  end
end
