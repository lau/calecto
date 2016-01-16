# Changelog for Calecto

## [0.4.4] - 2016-01-16
### Added

- Add cast! functions that return the result directly instead of wrapped
  in a tuple with :ok.

## [0.4.3] - 2015-12-10
### Added

- Accept Calendar versions ~> 0.12.0

## [0.4.2] - 2015-11-07
### Added

- Accept Calendar versions ~> 0.11.1

## [0.4.1] - 2015-10-23
### Added

- Implementation of protocols for Ecto types:
  Calendar.ContainsTime for Ecto.Time, Ecto.DateTime
  Calendar.ContainsDate for Ecto.Date, Ecto.DateTime
  Calendar.ContainsNaiveDateTime for Ecto.DateTime

## [0.4.0] - 2015-09-24
### Changed

- Calecto Date, Time, DateTimeUTC, NaiveDateTime now have their own struct.
  They will be returned instead of the Calendar equivalent.
  Before a Calecto.DateTimeUTC type would load as a Calendar.DateTime struct.
  But now it is a Calecto.DateTimeUTC struct. Because of protocols, they can
  still be used with the Calendar functions for formatting, timezone shifting
  etc.

## [0.3.10] - 2015-09-08
### Fixes

- Fix date query problems by allowing casting tuple date (Daniel Farrell)

## [0.3.9] - 2015-08-25
### Added

- Support for Ecto 1.0
- Support for Calendar 0.10.0

## [0.3.8] - 2015-08-13
### Added

- Compatibility with Calendar ~> 0.9.0
- Map casting for Time (Fabian Keunecke)
- Map casting for DateTimeUTC and DateTime

## [0.3.7] - 2015-08-10
### Fixed

- Works with Ecto 0.15. No longer relies on internal Ecto.DateTime.Util API.

### Added

- Map casting for Date (Fabian Keunecke)

### Changed

- Requires Calendar version ~> 0.8.1

## [0.3.6] - 2015-07-13
### Changed

- Added compatibility with Calendar 0.8.0

### Fixed

- add_type_migration mix task had wrong file name (started with kalecto)

## [0.3.5] - 2015-07-08
### Changed

- Added compatibility with Calendar 0.7.0

## [0.3.4] - 2015-05-18
### Changed

- Changed name from Kalecto to Calecto
- Uses Calendar library instead of Kalends

## [0.3.3] - 2015-05-17
### Fixed

- Fixed: `use Calecto.Model` would not work on versions 0.10 and higher

### Added

`usec: true` option can now be added to `use Calecto.Model`.
Like this: `use Calecto.Model, usec: true`
This enables microseconds in inserted_at/updated_at timestamps.

### Changed

- No longer compatible with version 0.9.x

## [0.3.2] - 2015-05-16
### Changed

Allow higher versions of Ecto. Can now be used with
Ecto 0.9.x or higher 0.x versions.

## [0.3.1] - 2015-04-29
### Changed
Change in Ecto.Model:
Ecto.Model does no longer call `use Calecto.Model`.

### Upgrade instructions from 0.2.x

In case you have `use Calecto.Model` and do not have
`use Ecto.Model` in the same module, you should add
`use Ecto.Model` so that both are present. Example:

```elixir
defmodule Weather do
  use Ecto.Model
  use Calecto.Model

  schema "weather" do
    field :city, :string
    timestamps
  end
end
```

## [0.2.2] - 2015-04-03
### Changed

- Corrected primitive type in Calecto.DateTime to :calendar_datetime
- Updated Calendar version to 0.6.2
- Support Ecto ~> 0.10.1

## [0.2.1] - 2015-03-19
### Added

Calecto.DateTime cast function.

## [0.2.0] - 2015-03-18
### Added

Calecto.DateTime added. The use of this type requires a composite
Postgres type, which can be added with a migration.

## [0.1.2] - 2015-03-16
### Added

Calecto.Model added with "use macro" that default timestamps to
Calecto.DateTimeUTC.

## [0.1.1] - 2015-03-13
### Changed

DateTimeUTC loading made faster.

## [0.1.0] - 2015-03-08
### Changed

Supports Ecto 0.9.0. No longer supports Ecto 0.8.x.

### Added
Support for microseconds.
