defmodule TimeTest do
  use ExUnit.Case

  @calecto_time %Calecto.Time{hour: 10, min: 42, sec: 53}
  @calecto_time_with_usec %Calecto.Time{hour: 10, min: 42, sec: 53, usec: 12}
  @calecto_time_without_sec %Calecto.Time{hour: 10, min: 42, sec: 0}
  @calendar_time %Calendar.Time{hour: 10, min: 42, sec: 53}
  @calendar_time_with_usec %Calendar.Time{hour: 10, min: 42, sec: 53, usec: 12}
  @calendar_time_without_sec %Calendar.Time{hour: 10, min: 42, sec: 0}
  @map_time %{"hour" => "10", "min" => "42", "sec" => "53"}
  @map_time_without_sec %{"hour" => "10", "min" => "42"}
  @tuple_time {10, 42, 53}
  @tuple_time_with_usec_zero {10, 42, 53, 0}
  @tuple_time_with_usec {10, 42, 53, 12}
  @tuple_time_without_sec {10, 42, 0, 0}

  test "dump Time" do
    assert Calecto.Time.dump(@calecto_time) == {:ok, @tuple_time_with_usec_zero}
    assert Calecto.Time.dump(@calecto_time_without_sec) == {:ok, @tuple_time_without_sec}
  end

  test "load Time" do
    assert Calecto.Time.load(@tuple_time) == {:ok, @calecto_time}
    assert Calecto.Time.load(@tuple_time_with_usec) == {:ok, @calecto_time_with_usec}
  end

  test "cast Time" do
    assert Calecto.Time.cast(@calecto_time) == {:ok, @calecto_time}
    assert Calecto.Time.cast(@calendar_time) == {:ok, @calecto_time}
    assert Calecto.Time.cast(@calendar_time_with_usec) == {:ok, @calecto_time_with_usec}
    assert Calecto.Time.cast(@map_time) == {:ok, @calecto_time}
    assert Calecto.Time.cast(@tuple_time_with_usec) == {:ok, @calecto_time_with_usec}
    assert Calecto.Time.cast(@map_time_without_sec) == {:ok, @calecto_time_without_sec}
  end

  test "cast tuple" do
    assert Calecto.Time.cast(@tuple_time) == {:ok, @calecto_time}
  end

  test "cast!" do
    assert Calecto.Time.cast!(@tuple_time) == @calecto_time
  end
end
