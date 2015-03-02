defmodule DateTimeUTCTest do
  use ExUnit.Case

  test "dump UTC DateTime" do
    utc_dt = Kalends.DateTime.from_erl!({{2001,1,1},{0,0,0}}, "Etc/UTC")
    assert Kalecto.DateTimeUTC.dump(utc_dt) == {:ok, {{2001, 1, 1}, {0, 0, 0}}}
  end

  test "dump non UTC DateTime should result in error" do
    non_utc_dt = Kalends.DateTime.from_erl!({{2001,1,1},{0,0,0}}, "Europe/Stockholm")
    assert Kalecto.DateTimeUTC.dump(non_utc_dt) == :error
  end

  test "cast UTC DateTime" do
    utc_dt = Kalends.DateTime.from_erl!({{2001,1,1},{0,0,0}}, "Etc/UTC")
    assert Kalecto.DateTimeUTC.cast(utc_dt) == {:ok, utc_dt}
  end

  test "cast non UTC DateTime should result in error" do
    non_utc_dt = Kalends.DateTime.from_erl!({{2001,1,1},{0,0,0}}, "Europe/Stockholm")
    assert Kalecto.DateTimeUTC.cast(non_utc_dt) == :error
  end
end
