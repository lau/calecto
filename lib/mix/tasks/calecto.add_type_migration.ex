defmodule Mix.Tasks.Calecto.AddTypeMigration do
  use Mix.Task
  import Mix.Generator
  import Mix.Ecto

  @migration_name "AddCalendarDateTimeType"

  def run(args) do
    path = "#{Mix.Project.app_path}/priv/repo/migrations/"
    Mix.Task.run "app.start", args
    repo = parse_repo(args) |> hd
    filename = "#{timestamp()}_add_datetime_type.exs"
    file = Path.join(path, filename)
    create_directory path
    create_file file, migration_template(mod:
                        Module.concat([repo, Migrations, @migration_name]))
  end

  defp timestamp do
    Calendar.DateTime.now_utc
    |> Calendar.DateTime.Format.rfc3339(0)
    |> String.replace(~r/[^0-9]/, "")
  end

  embed_template :migration, """
  defmodule <%= inspect @mod %> do
    use Ecto.Migration

    def up do
      execute "CREATE TYPE calendar_datetime
               AS (wall_time timestamp,
                   total_off integer,
                   timezone  varchar(48))"
    end

    def down do
      execute "DROP TYPE calendar_datetime"
    end
  end
  """
end
