defmodule EctoTypesTest do
  require Ecto.DateTime
  use ExUnit.Case

  @erl_dt {{2001,2,27},{4,5,6}}
  @erl_date {2001,2,27}
  @erl_time {4,5,6}

  test "Ecto.DateTime should have protocol for ContainsNaiveDateTime" do
    ecto_dt = @erl_dt |> Ecto.DateTime.from_erl
    assert ecto_dt |> Calendar.NaiveDateTime.Format.asctime == "Tue Feb 27 04:05:06 2001"
  end
  test "Ecto.DateTime should have protocol for ContainsDate" do
    ecto_dt = @erl_dt |> Ecto.DateTime.from_erl
    assert ecto_dt |> Calendar.Date.day_of_week_name == "Tuesday"
  end
  test "Ecto.DateTime should have protocol for ContainsTime" do
    ecto_dt = @erl_dt |> Ecto.DateTime.from_erl
    assert ecto_dt |> Calendar.Time.twelve_hour_time == {4, 5, 6, 0, :am}
  end

  test "Ecto.Dateshould have protocol for ContainsDate" do
    ecto_date = @erl_date |> Ecto.Date.from_erl
    assert ecto_date |> Calendar.Date.day_of_week_name == "Tuesday"
  end

  test "Ecto.Time should have protocol for ContainsTime" do
    ecto_time = @erl_time |> Ecto.Time.from_erl
    assert ecto_time |> Calendar.Time.twelve_hour_time == {4, 5, 6, 0, :am}
  end
end
