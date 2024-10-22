defmodule TodoApp.Infrastructure.Repositories.PersonRepository do
  alias TodoApp.Model.Person
  import Logger

  @table_name "PERSONS"

  def get_all(adapter \\ Application.get_env(:todo_app, :database_adapter)[:adapter]) do
    sql = "SELECT * FROM #{@table_name}"
    try do
      {:ok, pid} = adapter.start()
      case adapter.query(pid, sql, []) do
        {:ok, %{rows: rows}} ->
          persons = Enum.map(rows, &map_row/1)
          {:ok, persons}
        {:error, reason} ->
          handle_error("Failed to fetch all persons", reason)
      end
    rescue
      error ->
        handle_error("Failed to establish connection", error)
    end
  end

  def get_by_id(id, adapter \\ Application.get_env(:todo_app, :database_adapter)[:adapter]) do
    sql = "SELECT * FROM #{@table_name} WHERE id = ?"
    try do
      {:ok, pid} = adapter.start()
      case adapter.query(pid, sql, [id]) do
        {:ok, %{rows: [row]}} ->
          {:ok, map_row(row)}
          {:ok, %{rows: []}} ->
          {:error, "Person not found with the id #{id}"}
        {:error, reason} ->
          handle_error("Failed to fetch person with id #{id}", reason)
      end
    rescue
      error ->
        handle_error("Failed to establish connection", error)
    end
  end

  def create_person(person, adapter \\ Application.get_env(:todo_app, :database_adapter)[:adapter]) do
    case validate_person_fields(person) do
      {:ok, _message} ->
        sql = "INSERT INTO #{@table_name} (name) VALUES (?)"
        try do
          {:ok, pid} = adapter.start()
          case adapter.query(pid, sql, [person.name]) do
            {:ok, %{last_insert_id: id}} when is_integer(id) ->
              new_person = %Person{id: id} |> Map.merge(person)
              {:ok, new_person}
            {:error, reason} ->
              handle_error("Failed to create person", reason)
          end
        rescue
          error ->
            handle_error("Failed to establish connection", error)
        end
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp validate_person_fields(person) do
    if String.trim(person.name) == "" do
      {:error, "Person name cannot be empty"}
    else
      {:ok, "Fields validated successfully"}
    end
  end



  def update_person_by_id(id, updates, adapter \\ Application.get_env(:todo_app, :database_adapter)[:adapter]) do
    sql = "UPDATE #{@table_name} SET name = ? WHERE id = ?"
    try do
      {:ok, pid} = adapter.start()
      case adapter.query(pid, sql, [updates.name, id]) do
        {:ok, %{num_warnings: num_warnings, num_rows: num_rows}} when num_warnings == 0 and num_rows > 0 ->
          {:ok, %Person{id: id} |> Map.merge(updates)}

        {:ok, %{num_warnings: num_warnings, num_rows: num_rows}} when num_warnings != 0 or num_rows == 0 ->
          {:error, "Failed to update person with id #{id}"}
      end
    rescue
      error ->
        handle_error("Failed to establish connection", error)
    end
  end

  defp map_row([id, name]) do
    Person.new(id, name)
  end

  defp handle_error(message, reason) do
    error("#{message}. Reason: #{inspect(reason)}")
    {:error, message}
  end
end
