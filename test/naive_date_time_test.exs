defmodule NaiveDateTimeTest do
  use ExUnit.Case

  @kalends_ndt_sans_usec Kalends.NaiveDateTime.from_erl!({{2001,1,1},{1,2,3}})
  @kalends_ndt_zero_usec Kalends.NaiveDateTime.from_erl!({{2001,1,1},{1,2,3}}, 0)
  @kalends_ndt_with_usec Kalends.NaiveDateTime.from_erl!({{2001,1,1},{1,2,3}}, 2345)

  test "cast strings" do
    assert Kalecto.NaiveDateTime.cast("2001-01-01T01:02:03") == {:ok, @kalends_ndt_zero_usec}
    assert Kalecto.NaiveDateTime.cast("2001-01-01T01:02:03.002345") == {:ok, @kalends_ndt_with_usec}
  end

  test "dump NaiveDateTime" do
    assert Kalecto.NaiveDateTime.dump(@kalends_ndt_sans_usec) == {:ok, {{2001, 1, 1}, {1, 2, 3, 0}}}
    assert Kalecto.NaiveDateTime.dump(@kalends_ndt_with_usec) == {:ok, {{2001, 1, 1}, {1, 2, 3, 2345}}}
  end

  test "cast NaiveDateTime" do
    ndt = Kalends.NaiveDateTime.from_erl!({{2001,1,1},{1,2,3}})
    assert Kalecto.NaiveDateTime.cast(ndt) == {:ok, ndt}
  end
end
