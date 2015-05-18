defmodule DateTimeTest do
  use ExUnit.Case

  @mvd_calendar_dt_sans_usec Calendar.DateTime.from_erl!({{2001,1,1},{1,2,3}}, "America/Montevideo")
  @mvd_calendar_dt_zero_usec Calendar.DateTime.from_erl!({{2001,1,1},{1,2,3}}, "America/Montevideo", 0)
  @mvd_calendar_dt_with_usec Calendar.DateTime.from_erl!({{2001,1,1},{1,2,3}}, "America/Montevideo", 2345)

  test "dump DateTime" do
    assert Calecto.DateTime.dump(@mvd_calendar_dt_sans_usec) == {:ok, {{{2001, 1, 1}, {1, 2, 3, 0}}, -10800, "America/Montevideo"}}
    assert Calecto.DateTime.dump(@mvd_calendar_dt_with_usec) == {:ok, {{{2001, 1, 1}, {1, 2, 3, 2345}}, -10800, "America/Montevideo"}}
  end

  test "load DateTime" do
    assert Calecto.DateTime.load({{{2001, 1, 1}, {1, 2, 3, 2345}}, -10800, "America/Montevideo"}) == {:ok, @mvd_calendar_dt_with_usec}
  end

  test "cast DateTime" do
    assert Calecto.DateTime.cast(@mvd_calendar_dt_with_usec) == {:ok, @mvd_calendar_dt_with_usec}
  end
end
