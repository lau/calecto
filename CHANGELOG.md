# Changelog for Kalecto

## [0.3.0] - 2015-04-29
### Changed
Change in Ecto.Model:
Ecto.Model does no longer call `use Kalecto.Model`.

### Upgrade instructions from 0.2.x

In case you have `use Kalecto.Model` and do not have
`use Ecto.Model` in the same module, you should add
`use Ecto.Model` so that both are present. Example:

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

## [0.2.2] - 2015-04-03
### Changed

- Corrected primitive type in Kalecto.DateTime to :kalends_datetime
- Updated Kalends version to 0.6.2
- Support Ecto ~> 0.10.1

## [0.2.1] - 2015-03-19
### Added

Kalecto.DateTime cast function.

## [0.2.0] - 2015-03-18
### Added

Kalecto.DateTime added. The use of this type requires a composite
Postgres type, which can be added with a migration.

## [0.1.2] - 2015-03-16
### Added

Kalecto.Model added with "use macro" that default timestamps to
Kalecto.DateTimeUTC.

## [0.1.1] - 2015-03-13
### Changed

DateTimeUTC loading made faster.

## [0.1.0] - 2015-03-08
### Changed

Supports Ecto 0.9.0. No longer supports Ecto 0.8.x.

### Added
Support for microseconds.
