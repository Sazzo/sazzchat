defmodule Sazzchat.Router do
  import Plug.Conn

  use Plug.Router

  plug(Plug.Static,
    at: "/",
    from: :sazzchat
  )
  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )
  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Hello World")
  end

  match _ do
    send_resp(conn, 404, "404")
  end

end
