defmodule Mix.Tasks.Kalecto.AddTypeMigration do
  use Mix.Task
  import Mix.Generator
  import Mix.Ecto

  @migration_name "AddKalendsDateTimeType"

  def run(args) do
    Mix.Task.run "app.start", args
    repo = parse_repo(args)
    ensure_repo(repo)
    filename = "#{timestamp}_add_datetime_type.exs"
    path = Path.relative_to(migrations_path(repo), Mix.Project.app_path)
    file = Path.join(path, filename)
    create_directory path
    create_file file, migration_template(mod:
                        Module.concat([repo, Migrations, @migration_name]))
  end

  defp timestamp do
    Kalends.DateTime.now_utc
    |> Kalends.DateTime.Format.rfc3339(0)
    |> String.replace(~r/[^0-9]/, "")
  end

  embed_template :migration, """
  defmodule <%= inspect @mod %> do
    use Ecto.Migration

    def up do
      execute "CREATE TYPE kalends_datetime
               AS (wall_time timestamp,
                   total_off integer,
                   timezone  varchar(48))"
    end

    def down do
      execute "DROP TYPE kalends_datetime"
    end
  end
  """
end
