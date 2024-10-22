defmodule TodoApp.EntryPoint.PersonController do
  alias TodoApp.UseCase.PersonUseCase
  alias TodoApp.Utils.DataTypeUtils


  use Plug.Router

  plug(CORSPlug,
    methods: ["GET", "POST","PUT"],
    headers: ["Content-Type", "Accept", "User-Agent"]
  )

  plug Plug.Logger, log: :debug
  plug (:match)
  plug Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Poison
  plug Plug.Telemetry, event_prefix: [:todo_app, :plug]
  plug (:dispatch)

  get "/persons/:id" do
    case PersonUseCase.get_person_by_id(conn.params["id"]) do
      {:ok, person,:} ->
        build_response(person, conn)
      {:error, reason} ->
        build_not_found(reason, conn)
    end
  end

  post "/persons" do
    with normalized_body <- DataTypeUtils.normalize(conn.body_params),
         {:ok, person} <- PersonUseCase.create_person(normalized_body) do
      build_response(person, conn)
    else
      {:error, message} ->
        build_bad_request(message, conn)
    end
  end


  get "/persons" do
    case PersonUseCase.get_all() do
      {:ok, persons} ->
        build_response(persons, conn)
      {:error, reason} ->
        build_bad_request(%{error: reason}, conn)
    end
  end

  put "/persons/:id" do
    with normalized_body <- DataTypeUtils.normalize(conn.body_params),
         {:ok, updated_person_map} <- PersonUseCase.update_person_by_id(conn.params["id"], normalized_body) do
      build_response(updated_person_map, conn)
    else
      {:error, message} ->
        build_bad_request(message, conn)
    end
  end

  defp build_response(%{status: status, body: body}, conn) do
    conn
    |> put_status(status)
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(body))
  end

  defp build_response(response, conn) do
    build_response(%{status: 200, body: response}, conn)
  end

  defp build_bad_request(reason, conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(400, Jason.encode!(%{error: reason}))
  end

  defp build_not_found(reason, conn) do
    conn
    |> put_status(404)
    |> put_resp_content_type("application/json")
    |> send_resp(404, Jason.encode!(%{error: reason}))
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end

end
