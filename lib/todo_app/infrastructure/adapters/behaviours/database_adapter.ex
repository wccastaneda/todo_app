defmodule TodoApp.Infrastructure.Adapters.Behaviours.DatabaseAdapter do

  @callback start(map()) :: {:ok, pid} | {:error, any()}
  @callback query(pid, String.t(), list()) :: {:ok, any()} | {:error, any()}

end
