defmodule TodoApp.Utils.DataTypeUtils do
  require Logger

  @moduledoc """
  Provides functions for normalize data
  """

  def normalize(%{} = map) do
    Map.to_list(map)
    |> Enum.map(fn {key, value} -> {String.to_atom(key), normalize(value)} end)
    |> Enum.into(%{})
  end
  def normalize(value) when is_list(value), do: Enum.map(value, &normalize/1)
  def normalize(value), do: value

  # defp create_evaluator(name) do
  #   fn
  #     {^name, _} -> true
  #     _ -> false
  #   end
  # end

  def format("true", "boolean"), do: true
  def format("false", "boolean"), do: false

  def system_time_to_milliseconds(system_time) do
    system_time / 1.0e6
    |> round()
  end
  def monotonic_time_to_milliseconds(monotonic_time) do
    monotonic_time
    |> System.convert_time_unit(:native, :millisecond)
  end

  def start_time(), do: System.monotonic_time()
  def duration_time(start),
      do: (System.monotonic_time() - start)
          |> monotonic_time_to_milliseconds()

end
