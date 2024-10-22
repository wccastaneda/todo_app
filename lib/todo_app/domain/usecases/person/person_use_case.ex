defmodule TodoApp.UseCase.PersonUseCase do
  alias TodoApp.Model.PersonValidation
  alias TodoApp.Infrastructure.Repositories.PersonRepository

  @moduledoc """
  Provides functions for handling Person use cases.
  """

  def create_person(person) do
    with {:ok, true} <- PersonValidation.validate_not_null_person_name_and_regex(person) do
      case PersonRepository.create_person(person) do
        {:ok, new_person} ->
          {:ok, new_person}
        {:error, reason} ->
          {:error, reason}
      end
    end
  end


  def get_all() do
    case PersonRepository.get_all() do
      {:ok, persons} ->
        {:ok, persons}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def get_person_by_id(id) do
    case PersonRepository.get_by_id(id) do
      {:ok, person} ->
        {:ok, person}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def update_person_by_id(id, updates) do
    case PersonRepository.update_person_by_id(id, updates) do
      {:ok, updated_person} ->
        {:ok, updated_person}
      {:error, message} ->
        {:error, message}
    end
  end


end
