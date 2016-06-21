defmodule TimeTest do
  use ExUnit.Case

  @calendar_time %Time{hour: 10, minute: 42, second: 53}
  @calendar_time_with_usec %Time{hour: 10, minute: 42, second: 53, microsecond: {12, 6}}
  @calendar_time_without_sec %Time{hour: 10, minute: 42, second: 0}
  @map_time_legacy %{"hour" => "10", "min" => "42", "sec" => "53"} # legacy: `min` instead of `minute` etc.
  @map_time_without_sec_legacy %{"hour" => "10", "min" => "42"}
  @map_time %{"hour" => "10", "minute" => "42", "second" => "53"}
  @map_time_without_sec %{"hour" => "10", "minute" => "42"}
  @tuple_time {10, 42, 53}
  @tuple_time_with_usec_zero {10, 42, 53, 0}
  @tuple_time_with_usec {10, 42, 53, 12}
  @tuple_time_without_sec {10, 42, 0, 0}

  test "dump Time" do
    assert Calecto.Time.dump(@calendar_time) == {:ok, @tuple_time_with_usec_zero}
    assert Calecto.Time.dump(@calendar_time_without_sec) == {:ok, @tuple_time_without_sec}
  end

  test "load Time" do
    assert Calecto.Time.load(@tuple_time) == {:ok, @calendar_time}
    assert Calecto.Time.load(@tuple_time_with_usec) == {:ok, @calendar_time_with_usec}
  end

  test "cast Time" do
    assert Calecto.Time.cast(@calendar_time) == {:ok, @calendar_time}
    assert Calecto.Time.cast(@calendar_time_with_usec) == {:ok, @calendar_time_with_usec}
    assert Calecto.Time.cast(@tuple_time_with_usec) == {:ok, @calendar_time_with_usec}
    assert Calecto.Time.cast(@map_time) == {:ok, @calendar_time}
    assert Calecto.Time.cast(@map_time_without_sec) == {:ok, @calendar_time_without_sec}
    assert Calecto.Time.cast(@map_time_legacy) == {:ok, @calendar_time}
    assert Calecto.Time.cast(@map_time_without_sec_legacy) == {:ok, @calendar_time_without_sec}
  end

  test "cast tuple" do
    assert Calecto.Time.cast(@tuple_time) == {:ok, @calendar_time}
  end

  test "cast!" do
    assert Calecto.Time.cast!(@tuple_time) == @calendar_time
  end
end
