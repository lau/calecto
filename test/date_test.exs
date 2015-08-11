defmodule DateTest do
  use ExUnit.Case

  @date %Calendar.Date{day: 29, month: 7, year: 2015}
  @string_date "2015-07-29"
  @map_date %{"day" => "29", "month" => "7", "year" => "2015"}
  @tuple_date {2015, 7, 29}


  test "dump Date" do
    assert Calecto.Date.dump(@date) == {:ok, @tuple_date}
  end

  test "load Date" do
    assert Calecto.Date.load(@tuple_date) == {:ok, @date}
  end

  test "cast Date" do
    assert Calecto.Date.cast(@date) == {:ok, @date}
    assert Calecto.Date.cast(@string_date) == {:ok, @date}
    assert Calecto.Date.cast(@map_date) == {:ok, @date}
  end
end
