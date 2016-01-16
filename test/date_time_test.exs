defmodule DateTimeTest do
  use ExUnit.Case

  @mvd_calendar_dt_sans_usec     Calendar.DateTime.from_erl!({{2001,2,27},{1,2,3}}, "America/Montevideo")
  @mvd_calendar_dt_zero_usec     Calendar.DateTime.from_erl!({{2001,2,27},{1,2,3}}, "America/Montevideo", 0)
  @mvd_calendar_dt_with_usec     Calendar.DateTime.from_erl!({{2001,2,27},{1,2,3}}, "America/Montevideo", 2345)
  @mvd_calendar_dt_with_sec_zero Calendar.DateTime.from_erl!({{2001,2,27},{1,2,0}}, "America/Montevideo", 0)

  @map_dt        %{"day" => "27", "month" => "2", "year" => "2001", "hour" => "1", "min" => "2", "sec" => "3", "timezone" => "America/Montevideo"}
  @map_dt_usec   %{"day" => "27", "month" => "2", "year" => "2001", "hour" => "1", "min" => "2", "sec" => "3", "usec" => "2345", "timezone" => "America/Montevideo"}
  @map_dt_no_sec %{"day" => "27", "month" => "2", "year" => "2001", "hour" => "1", "min" => "2", "timezone" => "America/Montevideo"}

  test "dump DateTime" do
    assert Calecto.DateTime.dump(@mvd_calendar_dt_sans_usec) == {:ok, {{{2001, 2, 27}, {1, 2, 3, 0}}, -10800, "America/Montevideo"}}
    assert Calecto.DateTime.dump(@mvd_calendar_dt_with_usec) == {:ok, {{{2001, 2, 27}, {1, 2, 3, 2345}}, -10800, "America/Montevideo"}}
  end

  test "load DateTime" do
    assert Calecto.DateTime.load({{{2001, 2, 27}, {1, 2, 3, 2345}}, -10800, "America/Montevideo"}) == {:ok, @mvd_calendar_dt_with_usec}
  end

  test "cast DateTime" do
    assert Calecto.DateTime.cast(@mvd_calendar_dt_with_usec) == {:ok, @mvd_calendar_dt_with_usec}
  end

  test "cast bang DateTime" do
    assert Calecto.DateTime.cast!(@mvd_calendar_dt_with_usec) == @mvd_calendar_dt_with_usec
  end

  test "cast map" do
    assert Calecto.DateTime.cast(@map_dt) == {:ok, @mvd_calendar_dt_zero_usec}
    assert Calecto.DateTime.cast(@map_dt_usec) == {:ok, @mvd_calendar_dt_with_usec}
    assert Calecto.DateTime.cast(@map_dt_no_sec) == {:ok, @mvd_calendar_dt_with_sec_zero}
  end

  test "cast map invalid datetimes" do
    assert Calecto.DateTime.cast(%{"day" => "27", "month" => "2", "year" => "2001",
                                 "hour" => "1", "min" => "2",
                                 "timezone" => "Fake/Narnia"}) == {:error, :timezone_not_found}
    assert Calecto.DateTime.cast(%{"day" => "27", "month" => "2", "year" => "2001",
                                 "hour" => "99", "min" => "2",
                                 "timezone" => "Europe/Stockholm"}) == {:error, :invalid_datetime}
  end
end
