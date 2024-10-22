defmodule TodoApp.Infrastructure.Adapters.MySQLAdapter do
  @behaviour TodoApp.Infrastructure.Adapters.Behaviours.DatabaseAdapter

  import Logger

  def start(config \\ Application.get_env(:todo_app, :database_adapter)[:config]) do
    hostname = Map.get(config, :hostname)
    username = Map.get(config, :username)
    password = Map.get(config, :password)
    database = Map.get(config, :database)

    case MyXQL.start_link(hostname: hostname, username: username, password: password, database: database) do
      {:ok, pid} ->
        info("MySQL connection established successfully.")
        {:ok, pid}

      {:error, reason} ->
        handle_error("Failed to establish MySQL connection", reason)
    end
  end


  def query(pid, sql, params) do
    case MyXQL.query(pid, sql, params) do
      {:ok, %MyXQL.Result{} = result} ->
        {:ok, %{result | rows: result.rows || [], last_insert_id: result.last_insert_id || nil, num_warnings: result.num_warnings || 0, num_rows: result.num_rows || 0}}
      {:error, reason} ->
        handle_error("Query execution failed", reason)
    end
  end

  defp handle_error(message, reason) do
    error("#{message}. Reason: #{reason}")
    {:error, reason}
  end
end
