defmodule Infrastructure.EntryPoints.PeronsEntryPointTest do
  alias TodoApp.UseCase.PersonUseCase
  alias TodoApp.EntryPoint.PersonController

  use ExUnit.Case
  use Plug.Test
  import Mock

  @opts PersonController.init([])

  describe "Person Controller Test" do
    test "Should response code 200" do
      cnx = conn(:get, "/persons")
      expected_status = 200

      with_mocks [
        {PersonUseCase,[], [get_all: fn  -> {:ok,[]}  end]}
      ] do
      response = PersonController.call(cnx, @opts)
      assert expected_status == response.status
      end

    end



    test "Should response a bad request" do
      cnx = conn(:get, "/persons")
      expected_status = 400
      with_mocks [
        {PersonUseCase,[],   [get_all: fn  -> {:error,"Failed to fetch all persons"}  end]}
      ] do
      response = PersonController.call(cnx, @opts)
      assert expected_status == response.status
      end

    end

    test "Should create a person with 200 status code" do
      conn = conn(:post, "/persons",%{name: "TEST"})
      expected_status = 200
      expected_response = %{id: 1, name: "TEST"}

      with_mocks [
        {PersonUseCase, [], [create_person: fn %{name: "TEST"} -> {:ok, expected_response} end]}
      ] do
        response = PersonController.call(conn, @opts)
        assert expected_status == response.status
      end
    end

    test "Should try to create a person with 400 status code" do
      conn = conn(:post, "/persons",%{name: "TEST"})
      expected_status = 400
      expected_response = %{id: 1, name: "TEST"}

      with_mocks [
        {PersonUseCase, [], [create_person: fn %{name: "TEST"} -> {:error, "Error"} end]}
      ] do
        response = PersonController.call(conn, @opts)
        assert expected_status == response.status
      end
    end



  end


end
