defmodule DateTimeUTCTest do
  use ExUnit.Case
  alias Kalecto.DateTimeUTC

  @utc_kalends_dt_sans_usec Kalends.DateTime.from_erl!({{2001,1,1},{1,2,3}}, "Etc/UTC")
  @utc_kalends_dt_zero_usec Kalends.DateTime.from_erl!({{2001,1,1},{1,2,3}}, "Etc/UTC", 0)
  @utc_kalends_dt_with_usec Kalends.DateTime.from_erl!({{2001,1,1},{1,2,3}}, "Etc/UTC", 2345)

  test "cast strings" do
    assert DateTimeUTC.cast("2001-01-01T01:02:03") == {:ok, @utc_kalends_dt_zero_usec}
    assert DateTimeUTC.cast("2001-01-01T01:02:03Z") == {:ok, @utc_kalends_dt_zero_usec}
    assert DateTimeUTC.cast("2001-01-01T01:02:03.002345Z") == {:ok, @utc_kalends_dt_with_usec}
  end

  test "dump UTC DateTime" do
    assert DateTimeUTC.dump(@utc_kalends_dt_sans_usec) == {:ok, {{2001, 1, 1}, {1, 2, 3, 0}}}
    assert DateTimeUTC.dump(@utc_kalends_dt_with_usec) == {:ok, {{2001, 1, 1}, {1, 2, 3, 2345}}}
  end

  test "dump non UTC DateTime should result in error" do
    non_utc_dt = Kalends.DateTime.from_erl!({{2001,1,1},{1,2,3}}, "Europe/Stockholm")
    assert DateTimeUTC.dump(non_utc_dt) == :error
  end

  test "cast UTC DateTime" do
    utc_dt = Kalends.DateTime.from_erl!({{2001,1,1},{1,2,3}}, "Etc/UTC")
    assert DateTimeUTC.cast(utc_dt) == {:ok, utc_dt}
  end

  test "cast non UTC DateTime should result in error" do
    non_utc_dt = Kalends.DateTime.from_erl!({{2001,1,1},{1,2,3}}, "Europe/Stockholm")
    assert DateTimeUTC.cast(non_utc_dt) == :error
  end
end
