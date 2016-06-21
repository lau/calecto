defmodule EctoDataTypesTest do
  require Ecto.DateTime
  use ExUnit.Case

  test "Ecto datatype dump for Calendar.Time" do
    assert Ecto.DataType.dump(%Time{hour: 23, minute: 50, second: 50}) == {:ok, {23, 50, 50, 0}}
  end
  test "Ecto datatype dump for Calendar.Date" do
    assert Ecto.DataType.dump(%Date{month: 12, day: 20, year: 2000}) == {:ok, {2000, 12, 20}}
  end
  test "Ecto datatype dump for Calendar.NaiveDateTime" do
    assert Ecto.DataType.dump(%NaiveDateTime{hour: 23, minute: 50, second: 50, month: 12, day: 20, year: 2000}) == {:ok, {{2000, 12, 20}, {23, 50, 50, 0}}}
  end
  test "Ecto datatype dump for Calendar.DateTime" do
    assert Ecto.DataType.dump(%DateTime{hour: 23, minute: 50, second: 50, month: 12, day: 20, year: 2000, time_zone: "Etc/UTC", utc_offset: 0, std_offset: 0, zone_abbr: "UTC"}) == {:ok, {{2000, 12, 20}, {23, 50, 50, 0}}}
  end
end
