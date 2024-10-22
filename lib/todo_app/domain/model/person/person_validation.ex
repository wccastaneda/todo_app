defmodule TodoApp.Model.PersonValidation do
  def validate_not_null_person_name_and_regex(%{name: name}) when is_binary(name) and byte_size(name) > 0 do
    if String.match?(name, ~r/^[a-zA-Z\s]*$/) do
      {:ok, true}
    else
      {:error, "Invalid person data: name must contain only alphabetic characters"}
    end
  end

  def validate_not_null_person_name_and_regex(%{} = person) when map_size(person) > 0 do
    {:error, "Invalid person data: name cannot be null or empty"}
  end

  def validate_not_null_person_name_and_regex(_), do: {:error, "Invalid person data: body cannot be empty"}
end
