defmodule Sazzchat.SocketHandler do
  @behaviour :cowboy_websocket

  def init(request, _state) do
    state = %{registry_key: request.path}

    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    Registry.Sazzchat
    |> Registry.register(state.registry_key, {})

    {:ok, state}
  end

  def websocket_handle({:text, json}, state) do
    with {:ok, json} <- Poison.decode(json) do
      case json do
        %{"op" => op, "d" => d} ->
          handler(op, d, state)
      end
    end
  end

  def websocket_info({:message, content}, state) do
    replyMessage = Jason.encode!(%{"op" => "new_message", "d" => %{"content" => content}})
    {:reply, {:text, replyMessage}, state}
  end

  def handler("send_message", %{"content" => content}, state) do
    Registry.Sazzchat
    |> Registry.dispatch(state.registry_key, fn(entries) ->
      for {pid, _} <- entries do
        if pid != self() do
          Process.send(pid, {:message, content}, [])
        end
      end
    end)

    replyMessage = Jason.encode!(%{"op" => "message_received", "d" => %{"content" => content}})

    {:reply, {:text, replyMessage}, state}
  end
end
