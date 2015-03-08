Kalecto
=======

Glue between Kalends and Ecto.
For saving dates, times and datetimes in Ecto.

```elixir
    defp deps do
      [  {:kalecto, ">= 0.1.0"},  ]
    end
```
The types are:

| Ecto type             | Primitive type             | Kalends type
| ----------------------|----------------------------|---------------------------|
| Kalecto.Date          | date                       | Kalends.Date              |
| Kalecto.Time          | time                       | Kalends.Time              |
| Kalecto.DateTimeUTC   | datetime                   | Kalends.DateTime          |
| Kalecto.NaiveDateTime | datetime                   | Kalends.NaiveDateTime     |

If you have a datetime as a primitive type, you can use NaiveDateTime or DateTimeUTC.
If you have a date as a primitive type, you can use Kalecto.Date.
If you have a time as a primitive type, you can use Kalecto.Time.

Microseconds of NaiveDateTime and DateTimeUTC are discarded/ignored if present.
It is planned to include microseconds after a newer version of Ecto is released.

## Example usage

In your Ecto schema:

```elixir
  schema "weather" do
    field :city, :string
    field :nice_date, Kalecto.Date
    field :nice_time, Kalecto.Time
    field :nice_datetime, Kalecto.DateTimeUTC
    field :another_datetime, Kalecto.NaiveDateTime
    timestamps type: Kalecto.DateTimeUTC
  end
```

If you have a Kalends DateTime in the Etc/UTC timezone
you can save it in Ecto as a DateTimeUTC.

Let's create a new DateTime to represent "now":

```elixir
    iex> example_to_be_saved_in_db = Kalends.DateTime.now_utc
    %Kalends.DateTime{abbr: "UTC", day: 2, hour: 16, usec: 245828, min: 48,
     month: 3, sec: 19, std_off: 0, timezone: "Etc/UTC", utc_off: 0, year: 2015}
```

Another way of getting a DateTime is parsing JavaScript style milliseconds:

```elixir
    iex> parsed_datetime = Kalends.DateTime.Parse.js_ms!("1425314899000")
    %Kalends.DateTime{abbr: "UTC", day: 2, hour: 16, usec: 0, min: 48, month: 3,
     sec: 19, std_off: 0, timezone: "Etc/UTC", utc_off: 0, year: 2015}
```

Since the field nice_datetime is of the DateTimeUTC type, we can save
Kalends.DateTime structs there if they are in the Etc/UTC timezone:

```elixir
    weather_struct_to_be_saved = %Weather{nice_datetime: parsed_datetime}
```

When a Kalecto.DateTimeUTC type is received from the database it is loaded as a
Kalends.DateTime struct. We can use the functions in Kalends to shift this UTC
datetime to another time zone:

```elixir
    iex> example_loaded_from_db |> Kalends.DateTime.shift_zone!("Europe/Copenhagen")
    %Kalends.DateTime{abbr: "CET", day: 2, hour: 17, usec: nil, min: 48,
      month: 3, sec: 19, std_off: 0, timezone: "Europe/Copenhagen", utc_off: 3600,
      year: 2015}
```

Or we could get the unix timestamp:

```elixir
    iex> example_loaded_from_db |> Kalends.DateTime.Format.unix
    1425314899
```

Or format it via strftime:

```elixir
    iex> example_loaded_from_db |> Kalends.DateTime.Format.strftime!("The time is %T and it is %A.")
    "The time is 16:48:19 and it is Monday."
```

More information about Kalends functionality in the Kalends documentation: http://hexdocs.pm/kalends/

## Roadmap

- The next planned feature is being able to save DateTime structs that are not
  UTC. Saved DateTimes should preserve the timezone, hour, minute etc. If a
  timezone's rules/offset is changed the best case scenario is that the only
  thing that changes when the DateTime is loaded from the db is the offset.
