defmodule DateTimeUtcTest do
  use ExUnit.Case
  alias Calecto.DateTimeUTC

  @utc_calendar_dt_sans_usec     Calendar.DateTime.from_erl!({{2001,7,29},{1,2,3}}, "Etc/UTC")
  @utc_calendar_dt_zero_usec     Calendar.DateTime.from_erl!({{2001,7,29},{1,2,3}}, "Etc/UTC", 0)
  @utc_calendar_dt_with_sec_zero Calendar.DateTime.from_erl!({{2001,7,29},{1,2,0}}, "Etc/UTC", 0)
  @utc_calendar_dt_with_usec     Calendar.DateTime.from_erl!({{2001,7,29},{1,2,3}}, "Etc/UTC", 2345)

  @map_dt        %{"day" => "29", "month" => "7", "year" => "2001", "hour" => "1", "minute" => "2", "second" => "3"}
  @map_dt_usec   %{"day" => "29", "month" => "7", "year" => "2001", "hour" => "1", "minute" => "2", "second" => "3", "microsecond" => 2345}
  @map_dt_no_sec %{"day" => "29", "month" => "7", "year" => "2001", "hour" => "1", "minute" => "2"}
  @map_dt_legacy %{"day" => "29", "month" => "7", "year" => "2001", "hour" => "1", "min" => "2", "sec" => "3"}
  @map_dt_usec_legacy   %{"day" => "29", "month" => "7", "year" => "2001", "hour" => "1", "min" => "2", "sec" => "3", "usec" => 2345}
  @map_dt_no_sec_legacy %{"day" => "29", "month" => "7", "year" => "2001", "hour" => "1", "min" => "2"}

  test "cast strings" do
    assert DateTimeUTC.cast("2001-07-29T01:02:03") == {:ok, @utc_calendar_dt_zero_usec}
    assert DateTimeUTC.cast("2001-07-29T01:02:03Z") == {:ok, @utc_calendar_dt_zero_usec}
    assert DateTimeUTC.cast("2001-07-29T01:02:03.002345Z") == {:ok, @utc_calendar_dt_with_usec}
  end

  test "cast map" do
    assert DateTimeUTC.cast(@map_dt) == {:ok, @utc_calendar_dt_zero_usec}
    assert DateTimeUTC.cast(@map_dt_usec) == {:ok, @utc_calendar_dt_with_usec}
    assert DateTimeUTC.cast(@map_dt_no_sec) == {:ok, @utc_calendar_dt_with_sec_zero}
  end

  test "cast map pre-Elixir 1.3" do
    assert DateTimeUTC.cast(@map_dt_legacy) == {:ok, @utc_calendar_dt_zero_usec}
    assert DateTimeUTC.cast(@map_dt_usec_legacy) == {:ok, @utc_calendar_dt_with_usec}
    assert DateTimeUTC.cast(@map_dt_no_sec_legacy) == {:ok, @utc_calendar_dt_with_sec_zero}
  end

  test "dump UTC DateTime" do
    assert DateTimeUTC.dump(@utc_calendar_dt_zero_usec) == {:ok, {{2001, 7, 29}, {1, 2, 3, 0}}}
  end

  test "dump non UTC DateTime should result in error" do
    non_utc_dt = Calendar.DateTime.from_erl!({{2001,7,29},{1,2,3}}, "Europe/Stockholm")
    assert DateTimeUTC.dump(non_utc_dt) == :error
  end

  test "cast UTC DateTime" do
    utc_dt = Calendar.DateTime.from_erl!({{2001,7,29},{1,2,3}}, "Etc/UTC")
    assert DateTimeUTC.cast(utc_dt) == {:ok, @utc_calendar_dt_sans_usec}
  end

  test "cast! UTC DateTime" do
    utc_dt = Calendar.DateTime.from_erl!({{2001,7,29},{1,2,3}}, "Etc/UTC")
    assert DateTimeUTC.cast!(utc_dt) == @utc_calendar_dt_sans_usec
  end

  test "cast Calecto DateTimeUTC" do
    assert DateTimeUTC.cast(@utc_calendar_dt_with_usec) == {:ok, @utc_calendar_dt_with_usec}
  end

  test "cast non UTC DateTime should result in error" do
    non_utc_dt = Calendar.DateTime.from_erl!({{2001,7,29},{1,2,3}}, "Europe/Stockholm")
    assert DateTimeUTC.cast(non_utc_dt) == :error
  end
end
