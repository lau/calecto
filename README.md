Calecto
=======

[![Build
Status](https://travis-ci.org/lau/calecto.svg?branch=master)](https://travis-ci.org/lau/calecto)
[![Hex Version](http://img.shields.io/hexpm/v/calecto.svg?style=flat)](https://hex.pm/packages/calecto)

Library to make it easy to use [Calendar](https://github.com/lau/calendar) and
[Ecto](https://github.com/elixir-lang/ecto) together.
For saving dates, times and datetimes in Ecto. Instead of using the Ecto
types for Date, Time and DateTime, you can access the features of the Calendar
library. With timezone awareness, parsing, and formatting functionality.

For use with Elixir 1.3 and Calendar ~> 0.16 add the following version to your deps:

```elixir
defp deps do
  [ {:calecto, "~> 0.16.0"}, ]
end
```

If you use a Calendar version earlier than 0.16, use Calecto version ~> 0.6.1

## Super quick way to get started

Here's how to display `inserted_at` and `updated_at` dates using the
functionality of the Calendar library:

- Add :calecto to your deps in your mix.exs file (see above) and run `mix deps.get`

### If you are using Phoenix

- If you are Phoenix you can add the line `use Calecto.Schema` in the file
`web/web.ex` in the `model` function definition like so:

```elixir
def model do
  quote do
    use Ecto.Schema
    use Calecto.Schema, usec: true

    # ...
  end
end
```

### If you are not using Phoenix

- An alternative method to adding the line in `web/web.ex` is the following:
  In your Ecto models, where you have a schema definition with a `timestamps`
  line, under the line that says `use Ecto.Schema` add `use Calecto.Schema` like so:

```elixir
defmodule Weather do
  use Ecto.Schema
  use Calecto.Schema, usec: true

  schema "weather" do
    field :city, :string
    timestamps
  end
end
```

### Formatting timestamps

This means that your timestamps will be loaded as `DateTime` structs
instead of Ecto.DateTime structs. You can use the formatting functionality
in Calendar.

- Format an `inserted_at` timestamp using Calendar:

```elixir
@post.inserted_at |> Calendar.Strftime.strftime!("%A, %e %B %Y")
```
It will return for instance: `Monday, 9 March 2015`

There are other formatting functions. For instance: http timestamp, unix
timestamp, RFC 3339 (ISO 8601). You can also shift the timestamp to another
timezone in order to display what date and time it was in that particular
timezone. See more in the [Calendar documentation](http://hexdocs.pm/calendar/).

## The types

If you have a primitive type as listed below you can swap it for a Calecto type
simply by adding the type to your Ecto schema.

| Primitive type            | Ecto schema type      | Equivalent Calendar type |
| ------------------------- | --------------------- | ------------------------ |
| *Used in migrations*      | *Used in schemas*     | *Type returned from db*  |
| :date                     | Calecto.Date          | Date                     |
| :time                     | Calecto.Time          | Time                     |
| :datetime                 | Calecto.DateTimeUTC   | DateTime                 |
| :datetime                 | Calecto.NaiveDateTime | NaiveDateTime            |
| :calendar_datetime        | Calecto.DateTime*     | DateTime                 |

If you have a `datetime` as a primitive type, you can use `Calecto.NaiveDateTime` or
`Calecto.DateTimeUTC`.
If you have a `date` as a primitive type, you can use `Calecto.Date`.
If you have a `time` as a primitive type, you can use `Calecto.Time`.

Put the primitive type in your migrations and the Ecto type in your schema.

*) If you are using Postgres as a database you can also use the Calecto.DateTime
type. This allows you to save any Calendar.DateTime struct. This is useful for
saving for instance future times for meetings in a certain timezone. Even if
timezone rules change, the "wall time" will stay the same. See the
"DateTime with Postgres" heading below.

## Example usage

In your Ecto schema:

```elixir
defmodule Weather do
  use Ecto.Schema
  use Calecto.Schema, usec: true

  schema "weather" do
    field :temperature,      :integer
    field :nice_date,        Calecto.Date
    field :nice_time,        Calecto.Time
    field :nice_datetime,    Calecto.DateTimeUTC
    field :another_datetime, Calecto.NaiveDateTime
    timestamps usec: true
    # the timestamps will be DateTimeUTC because of the `use Calecto.Schema` line
  end
end
```

If you have a Calendar DateTime in the Etc/UTC timezone
you can save it in Ecto as a DateTimeUTC.

Let's create a new DateTime to represent "now":

```elixir
    iex> example_to_be_saved_in_db = DateTime.utc_now
    %DateTime{calendar: Calendar.ISO, day: 30, hour: 15, microsecond: {46167, 6},
    minute: 47, month: 6, second: 15, std_offset: 0, time_zone: "Etc/UTC",
    utc_offset: 0, year: 2016, zone_abbr: "UTC"}
```

Another way of getting a DateTime is parsing JavaScript style milliseconds:

```elixir
    iex> parsed_datetime = Calendar.DateTime.Parse.js_ms!("1425314899000")
    %DateTime{calendar: Calendar.ISO, day: 2, hour: 16, microsecond: {0, 3},
    minute: 48, month: 3, second: 19, std_offset: 0, time_zone: "Etc/UTC",
    utc_offset: 0, year: 2015, zone_abbr: "UTC"}
```

Since the field `nice_datetime` is of the DateTimeUTC type, we can save
Calendar.DateTime structs there if they are in the Etc/UTC timezone:

```elixir
    weather_struct_to_be_saved = %Weather{nice_datetime: parsed_datetime}
```

The `DateTime` struct returned from the database can be used with
`Calendar.DateTime` functions. We could for instance use the functions in
Calendar to shift this UTC datetime to another time zone:

```elixir
    iex> example_loaded_from_db |> Calendar.DateTime.shift_zone!("Europe/Copenhagen")
    %DateTime{calendar: Calendar.ISO, day: 2, hour: 17, microsecond: {0, 3},
    minute: 48, month: 3, second: 19, std_offset: 0, time_zone: "Europe/Copenhagen",
    utc_offset: 3600, year: 2015, zone_abbr: "CET"}
```

Or we could get the unix timestamp:

```elixir
    iex> example_loaded_from_db |> Calendar.DateTime.Format.unix
    1425314899
```

Or format it via strftime:

```elixir
    iex> example_loaded_from_db |> Calendar.Strftime.strftime!("The time is %T and it is %A.")
    "The time is 16:48:19 and it is Monday."
```

The are many more possiblities with Calendar for formatting, parsing etc. Look
at the [Calendar documentation](http://hexdocs.pm/calendar/) for a detailed description.

## DateTime with Postgres

If you are using Postgres, you can save and load DateTime structs that are not
in the Etc/UTC timezone. This requires that a special type is added to the
database. By running the following command you can generate a migration that
adds this type:

```
    mix calecto.add_type_migration
```

Then run the migration (`mix ecto.migrate`). This adds the `calendar_datetime`
type to the Postgres database. In migrations you can use `:calendar_datetime`.

In the schemas you can use the type `Calecto.DateTime` for fields that have
been created with :calendar_datetime type in migrations.

## Documentation

[Documentation for Calecto is available at hexdocs.](http://hexdocs.pm/calecto/)

More information about Calendar functionality in the [Calendar documentation](http://hexdocs.pm/calendar/).

### Ecto 2.0.0-rc4

The autogenerated `timestamps` feature in Ecto 2.0.0-rc4 is incompatible with Calecto.
If you are using one of the Ecto 2.0.0 release candidates, use the newest version of
Calecto and Ecto 2.0.0-rc5 or higher.
