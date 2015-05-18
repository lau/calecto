defmodule NaiveDateTimeTest do
  use ExUnit.Case

  @calendar_ndt_sans_usec Calendar.NaiveDateTime.from_erl!({{2001,1,1},{1,2,3}})
  @calendar_ndt_zero_usec Calendar.NaiveDateTime.from_erl!({{2001,1,1},{1,2,3}}, 0)
  @calendar_ndt_with_usec Calendar.NaiveDateTime.from_erl!({{2001,1,1},{1,2,3}}, 2345)

  test "cast strings" do
    assert Calecto.NaiveDateTime.cast("2001-01-01T01:02:03") == {:ok, @calendar_ndt_zero_usec}
    assert Calecto.NaiveDateTime.cast("2001-01-01T01:02:03.002345") == {:ok, @calendar_ndt_with_usec}
  end

  test "dump NaiveDateTime" do
    assert Calecto.NaiveDateTime.dump(@calendar_ndt_sans_usec) == {:ok, {{2001, 1, 1}, {1, 2, 3, 0}}}
    assert Calecto.NaiveDateTime.dump(@calendar_ndt_with_usec) == {:ok, {{2001, 1, 1}, {1, 2, 3, 2345}}}
  end

  test "cast NaiveDateTime" do
    ndt = Calendar.NaiveDateTime.from_erl!({{2001,1,1},{1,2,3}})
    assert Calecto.NaiveDateTime.cast(ndt) == {:ok, ndt}
  end
end
