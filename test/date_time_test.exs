defmodule DateTimeTest do
  use ExUnit.Case

  @mvd_kalends_dt_sans_usec Kalends.DateTime.from_erl!({{2001,1,1},{1,2,3}}, "America/Montevideo")
  @mvd_kalends_dt_zero_usec Kalends.DateTime.from_erl!({{2001,1,1},{1,2,3}}, "America/Montevideo", 0)
  @mvd_kalends_dt_with_usec Kalends.DateTime.from_erl!({{2001,1,1},{1,2,3}}, "America/Montevideo", 2345)

  test "dump DateTime" do
    assert Kalecto.DateTime.dump(@mvd_kalends_dt_sans_usec) == {:ok, {{{2001, 1, 1}, {1, 2, 3, 0}}, -10800, "America/Montevideo"}}
    assert Kalecto.DateTime.dump(@mvd_kalends_dt_with_usec) == {:ok, {{{2001, 1, 1}, {1, 2, 3, 2345}}, -10800, "America/Montevideo"}}
  end

  test "load DateTime" do
    assert Kalecto.DateTime.load({{{2001, 1, 1}, {1, 2, 3, 2345}}, -10800, "America/Montevideo"}) == {:ok, @mvd_kalends_dt_with_usec}
  end
end
