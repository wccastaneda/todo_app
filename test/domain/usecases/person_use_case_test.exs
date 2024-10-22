defmodule Domain.UseCase.PersonUseCaseTest do
  use ExUnit.Case
  alias TodoApp.Infrastructure.Repositories.PersonRepository
  alias TodoApp.UseCase.PersonUseCase

  import Mock

  @id 123
  @updates %{name: "TEST_1"}
  @updates_base %{name: "TEST"}
  @person_test_mock_without_id %{name: "TEST"}
  @person_test_mock %{id: 1 ,name: "TEST"}
  @updated_person_test_mock %{id: 1 , name: "TEST_1"}
  @empty_test_mock %{name: ""}
  @bad_test_person_mock_with_regex %{name: "2"}

  describe "Person Use Case Test" do
    test "Not found person to update" do
      # Arrange
      with_mocks [
        {PersonRepository, [], [update_person_by_id: fn @id, @updates -> {:error, "Failed to update person with id #{@id}"} end]}
      ] do
      # Act
        {:error, reason} = PersonUseCase.update_person_by_id(@id, @updates)
      # Assert
        assert reason == "Failed to update person with id #{@id}"
      end
    end

    test "Update person" do
      # Arrange
      with_mocks [
        {PersonRepository, [], [update_person_by_id: fn @id, @updates -> {:ok, @updated_person_test_mock} end]}
      ] do
      # Act
        {:ok, person} = PersonUseCase.update_person_by_id(@id, @updates)
      # Assert
        assert person.name == @updates.name
      end
    end

    test "Get all persons use case" do
      # Arrange
      with_mocks [
        {PersonRepository, [], [get_all: fn  -> {:ok,[]} end]}
       ] do
      # Act
      {:ok, persons} = PersonUseCase.get_all()
      # Assert
      assert persons == []
      end
    end

    test "Get all with error from repository" do
      # Arrange
      with_mocks [
        {PersonRepository, [], [get_all: fn  -> {:error,"Failed to fetch all persons"} end]}
       ] do
      # Act
      {:error, reason} = PersonUseCase.get_all()
      # Assert
      assert reason == "Failed to fetch all persons"
      end
    end

    test "Get by Id with not found person" do
      # Arrange
      with_mocks [
        {PersonRepository, [], [get_by_id: fn @id -> {:error,"Person not found with the id #{@id}"} end]}
       ] do
      # Act
      {:error, reason} = PersonUseCase.get_person_by_id(@id)
      # Assert
      assert reason == "Person not found with the id #{@id}"
      end
    end

    test "Get by Id a person" do
      # Arrange
      with_mocks [
        {PersonRepository, [], [get_by_id: fn 1 -> {:ok,@person_test_mock} end]}
       ] do
      # Act
      {:ok, person} = PersonUseCase.get_person_by_id(1)
      # Assert
      assert person == @person_test_mock
      end
    end

    test "Create person use case with error in validation" do
      # Arrange
      with_mocks [
        {PersonRepository,[],[create_person: fn @empty_test_mock -> {:error,"Failed to create person"}  end]}
      ] do
      # Act
      {:error,reason} = PersonUseCase.create_person(@empty_test_mock)
      # Assert
      assert reason == "Invalid person data: name cannot be null or empty"
      end
    end

    test "Create person use case with success" do
      # Arrange
      with_mocks [
        {PersonRepository,[],[create_person: fn @updates_base -> {:ok,@person_test_mock}  end]}
      ] do
      # Act
      {:ok,person} = PersonUseCase.create_person(@updates_base)
      # Assert
      assert person == @person_test_mock
      end
    end

    test "Create person use case with error in validation with Regex" do
      # Arrange
      with_mocks [
        {PersonRepository,[],[create_person: fn @bad_test_person_mock_with_regex -> {:error,"Failed to create person"}  end]}
      ] do
      # Act
      {:error,reason} = PersonUseCase.create_person(@bad_test_person_mock_with_regex)
      # Assert
      assert reason == "Invalid person data: name must contain only alphabetic characters"
      end
    end

    test "Create person use case with empty data" do
      # Arrange
      with_mocks [
        {PersonRepository,[],[create_person: fn %{} -> {:error,"Failed to create person"}  end]}
      ] do
      # Act
      {:error,reason} = PersonUseCase.create_person(%{})
      # Assert
      assert reason == "Invalid person data: body cannot be empty"
      end
    end

    test "Create person use case with error from repository" do
      # Arrange
      with_mocks [
        {PersonRepository, [], [create_person: fn @empty_test_mock -> {:error, "Person name cannot be empty"} end]}
      ] do
        # Act
        {:error, reason} = PersonUseCase.create_person(@empty_test_mock)
        # Assert
        assert reason == "Invalid person data: name cannot be null or empty"
      end
    end
    

  end
end
