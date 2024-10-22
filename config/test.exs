import Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase
config :todo_app, timezone: "America/Bogota"

config :todo_app,
        port: 8083

config :todo_app, :database_adapter,
adapter: TodoApp.Infrastructure.Adapters.MySQLAdapter
