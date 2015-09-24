defmodule DateTimeUTCTest do
  use ExUnit.Case
  alias Calecto.DateTimeUTC

  @utc_calecto_dt_sans_usec     Calecto.DateTimeUTC.from_erl!({{2001,7,29},{1,2,3}})
  @utc_calecto_dt_zero_usec     Calecto.DateTimeUTC.from_erl!({{2001,7,29},{1,2,3,0}})
  @utc_calecto_dt_with_sec_zero Calecto.DateTimeUTC.from_erl!({{2001,7,29},{1,2,0,0}})
  @utc_calecto_dt_with_usec     Calecto.DateTimeUTC.from_erl!({{2001,7,29},{1,2,3,2345}})
  @utc_calendar_dt_sans_usec     Calendar.DateTime.from_erl!({{2001,7,29},{1,2,3}}, "Etc/UTC")
  @utc_calendar_dt_zero_usec     Calendar.DateTime.from_erl!({{2001,7,29},{1,2,3}}, "Etc/UTC", 0)
  @utc_calendar_dt_with_sec_zero Calendar.DateTime.from_erl!({{2001,7,29},{1,2,0}}, "Etc/UTC", 0)
  @utc_calendar_dt_with_usec     Calendar.DateTime.from_erl!({{2001,7,29},{1,2,3}}, "Etc/UTC", 2345)

  @map_dt        %{"day" => "29", "month" => "7", "year" => "2001", "hour" => "1", "min" => "2", "sec" => "3"}
  @map_dt_usec   %{"day" => "29", "month" => "7", "year" => "2001", "hour" => "1", "min" => "2", "sec" => "3", "usec" => 2345}
  @map_dt_no_sec %{"day" => "29", "month" => "7", "year" => "2001", "hour" => "1", "min" => "2"}

  test "cast strings" do
    assert DateTimeUTC.cast("2001-07-29T01:02:03") == {:ok, @utc_calecto_dt_zero_usec}
    assert DateTimeUTC.cast("2001-07-29T01:02:03Z") == {:ok, @utc_calecto_dt_zero_usec}
    assert DateTimeUTC.cast("2001-07-29T01:02:03.002345Z") == {:ok, @utc_calecto_dt_with_usec}
  end

  test "cast map" do
    assert DateTimeUTC.cast(@map_dt) == {:ok, @utc_calecto_dt_zero_usec}
    assert DateTimeUTC.cast(@map_dt_usec) == {:ok, @utc_calecto_dt_with_usec}
    assert DateTimeUTC.cast(@map_dt_no_sec) == {:ok, @utc_calecto_dt_with_sec_zero}
  end

  test "dump UTC DateTime" do
    assert DateTimeUTC.dump(@utc_calecto_dt_sans_usec) == {:ok, {{2001, 7, 29}, {1, 2, 3, 0}}}
    assert DateTimeUTC.dump(@utc_calecto_dt_with_usec) == {:ok, {{2001, 7, 29}, {1, 2, 3, 2345}}}
  end

  test "dump non UTC DateTime should result in error" do
    non_utc_dt = Calendar.DateTime.from_erl!({{2001,7,29},{1,2,3}}, "Europe/Stockholm")
    assert DateTimeUTC.dump(non_utc_dt) == :error
  end

  test "cast UTC DateTime" do
    utc_dt = Calendar.DateTime.from_erl!({{2001,7,29},{1,2,3}}, "Etc/UTC")
    assert DateTimeUTC.cast(utc_dt) == {:ok, @utc_calecto_dt_sans_usec}
  end

  test "cast Calecto DateTimeUTC" do
    assert DateTimeUTC.cast(@utc_calendar_dt_with_usec) == {:ok, @utc_calecto_dt_with_usec}
  end

  test "cast non UTC DateTime should result in error" do
    non_utc_dt = Calendar.DateTime.from_erl!({{2001,7,29},{1,2,3}}, "Europe/Stockholm")
    assert DateTimeUTC.cast(non_utc_dt) == :error
  end
end
