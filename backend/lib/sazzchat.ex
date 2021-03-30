defmodule Sazzchat do
  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Sazzchat.Router,
        options: [
          dispatch: dispatch(),
          port: 7575
        ]
      ),
      Registry.child_spec(
        keys: :duplicate,
        name: Registry.Sazzchat
      )
    ]

    opts = [strategy: :one_for_one, name: Sazzchat.Application]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_,
        [
          {"/socket", Sazzchat.SocketHandler, []},
          {:_, Plug.Cowboy.Handler, {Sazzchat.Router, []}}
        ]
      }
    ]
  end
end
