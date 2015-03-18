Kalecto
=======

[![Build
Status](https://travis-ci.org/lau/kalecto.svg?branch=master)](https://travis-ci.org/lau/kalecto)
[![Hex Version](http://img.shields.io/hexpm/v/kalecto.svg?style=flat)](https://hex.pm/packages/kalecto)

Glue between [Kalends](https://github.com/lau/kalends) and Ecto.
For saving dates, times and datetimes in Ecto.

```elixir
    defp deps do
      [  {:kalecto, ">= 0.2.0"},  ]
    end
```

## Super quick way to get started

Here's how to display `inserted_at` and `updated_at` dates using the
functionality of the Kalends library:

- Add :kalecto to your deps in your mix.exs file (see above) and run `mix deps.get`
- In your Ecto models, where you have a schema definition with a `timestamps`
  line, add `use Kalecto.Model` at the top of the module, below the line that
  says`use Ecto.Model`:

```elixir
defmodule Weather do
  use Ecto.Model
  use Kalecto.Model

  schema "weather" do
    field :city, :string
    timestamps
  end
end
```

This means that your timestamps will be loaded as Kalends.DateTime structs
instead of Ecto.DateTime structs and you can use the formatting functionality
in Kalends.

- Format an `inserted_at` timestamp using Kalends:

```elixir
@post.inserted_at |> Kalends.DateTime.Format.strftime!("%A, %e %B %Y")
```
It will return for instance: `Monday, 9 March 2015`

There are other formatting functions. For instance: http timestamp, unix
timestamp, RFC 3339 (ISO 8601). You can also shift the timestamp to another
timezone in order to display what date and time it was in that particular
timezone. See more in the [Kalends documentation](http://hexdocs.pm/kalends/).

## The types

If you have a primitive type as listed below you can swap it for a Kalecto type
simply by adding the type to your Ecto schema.

|  Primitive type             |Ecto type             |Kalends type
| ----------------------------|----------------------|------------------------|
|  date                       |Kalecto.Date          |Kalends.Date            |
|  time                       |Kalecto.Time          |Kalends.Time            |
|  datetime                   |Kalecto.DateTimeUTC   |Kalends.DateTime        |
|  datetime                   |Kalecto.NaiveDateTime |Kalends.NaiveDateTime   |
|  kalends_datetime           |Kalecto.DateTime*     |Kalends.DateTime        |

If you have a datetime as a primitive type, you can use NaiveDateTime or
DateTimeUTC.
If you have a date as a primitive type, you can use Kalecto.Date.
If you have a time as a primitive type, you can use Kalecto.Time.

*) If you are using Postgres as a database you can also use the Kalecto.DateTime
type. This allows you to save any Kalends.DateTime struct. This is useful for
saving for instance future times for meetings in a certain timezone. Even if
timezone rules change, the "wall time" will stay the same. See the
"DateTime with Postgres" heading below.

Microseconds of NaiveDateTime and DateTimeUTC are discarded/ignored if present.
It is planned to include microseconds after a newer version of Ecto is released.

## Example usage

In your Ecto schema:

```elixir
defmodule Weather do
  use Ecto.Model
  use Kalecto.Model

  schema "weather" do
    field :city,             :string
    field :nice_date,        Kalecto.Date
    field :nice_time,        Kalecto.Time
    field :nice_datetime,    Kalecto.DateTimeUTC
    field :another_datetime, Kalecto.NaiveDateTime
    timestamps
    # the timestamps will be DateTimeUTC because of the `use Kalecto.Model` line
  end
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

Since the field `nice_datetime` is of the DateTimeUTC type, we can save
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

## DateTime with Postgres

If you are using Postgres, you can save and load DateTime structs that are not
in the Etc/UTC timezone. This requires that a special type is added to the
database. By running the following command you can generate a migration that
adds this type:

```
    mix kalecto.add_type_migration
```

Then run the migration (`mix ecto.migrate`) and you can use the type
`Kalecto.DateTime`

More information about Kalends functionality in the [Kalends documentation](http://hexdocs.pm/kalends/).
