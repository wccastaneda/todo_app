defmodule TodoApp.Application do
  alias TodoApp.EntryPoint.PersonController

  @moduledoc false
  use Application

  def start(_type, _args) do

    children = [
      {Plug.Cowboy, scheme: :http, plug: PersonController, options: [port: Application.get_env(:todo_app, :port)]}
    ]

    opts = [strategy: :one_for_one, name: TodoApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
