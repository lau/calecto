defmodule NaiveDateTimeTest do
  use ExUnit.Case

  @calecto_ndt_sans_usec Calecto.NaiveDateTime.from_erl!({{2001,7,29},{1,2,3}})
  @calecto_ndt_zero_usec Calecto.NaiveDateTime.from_erl!({{2001,7,29},{1,2,3,0}})
  @calecto_ndt_with_sec_zero Calecto.NaiveDateTime.from_erl!({{2001,7,29},{1,2,0,0}})
  @calecto_ndt_with_usec Calecto.NaiveDateTime.from_erl!({{2001,7,29},{1,2,3,2345}})
  @calendar_ndt_sans_usec Calendar.NaiveDateTime.from_erl!({{2001,7,29},{1,2,3}})
  @calendar_ndt_zero_usec Calendar.NaiveDateTime.from_erl!({{2001,7,29},{1,2,3}}, 0)
  @calendar_ndt_with_sec_zero Calendar.NaiveDateTime.from_erl!({{2001,7,29},{1,2,0}}, 0)
  @calendar_ndt_with_usec Calendar.NaiveDateTime.from_erl!({{2001,7,29},{1,2,3}}, 2345)
  @map_ndt        %{"day" => "29", "month" => "7", "year" => "2001", "hour" => "1", "min" => "2", "sec" => "3"}
  @map_ndt_usec   %{"day" => "29", "month" => "7", "year" => "2001", "hour" => "1", "min" => "2", "sec" => "3", "usec" => 2345}
  @map_ndt_no_sec %{"day" => "29", "month" => "7", "year" => "2001", "hour" => "1", "min" => "2"}

  test "cast strings" do
    assert Calecto.NaiveDateTime.cast("2001-07-29T01:02:03") == {:ok, @calecto_ndt_zero_usec}
    assert Calecto.NaiveDateTime.cast("2001-07-29T01:02:03.002345") == {:ok, @calecto_ndt_with_usec}
  end

  test "cast map" do
    assert Calecto.NaiveDateTime.cast(@map_ndt) == {:ok, @calecto_ndt_zero_usec}
    assert Calecto.NaiveDateTime.cast(@map_ndt_usec) == {:ok, @calecto_ndt_with_usec}
    assert Calecto.NaiveDateTime.cast(@map_ndt_no_sec) == {:ok, @calecto_ndt_with_sec_zero}
  end

  test "cast" do
    assert Calecto.NaiveDateTime.cast(@calendar_ndt_with_usec) == {:ok, @calecto_ndt_with_usec}
    assert Calecto.NaiveDateTime.cast(@calecto_ndt_with_usec) == {:ok, @calecto_ndt_with_usec}
  end

  test "dump NaiveDateTime" do
    assert Calecto.NaiveDateTime.dump(@calecto_ndt_sans_usec) == {:ok, {{2001, 7, 29}, {1, 2, 3, 0}}}
    assert Calecto.NaiveDateTime.dump(@calecto_ndt_with_usec) == {:ok, {{2001, 7, 29}, {1, 2, 3, 2345}}}
  end
end
