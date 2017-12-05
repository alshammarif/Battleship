defmodule BattleshipWeb.GameRoomChannel do
  use BattleshipWeb, :channel
  alias Battleship.GameAgent

  intercept ["update"]

  def join("game:" <> game_id, payload, socket) do
    if !GameAgent.ongoing?(game_id) do
      {:ok, game_id} = GameAgent.create()
    end

    player_id = socket.assigns[:player_id]

    case GameAgent.add_player(game_id, player_id) do
      {:ok, game} ->
        socket= assign(socket, :game_id, game_id)
        oid = game["opponent"]["player_id"]
        if oid do
          {:ok, updates} = GameAgent.get_player_game(game_id, oid)
          Battleship.Endpoint.broadcast!("#{game_id}' game has been updated successfully: player added")
        end
        {:ok, game, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  #to place ships on a player's board
  def handle_in("place_ship", %{"fx" => fx, "fy" => fy}, socket) do
    gid = socket.assigns[:game_id]
    pid = socket.assigns[:player_id]
    case GameAgent.place_ship(gid, pid, fx: fx, fy: fy) do
      {:ok, _} ->
        {:ok, game} = GameAgent.get_player_game(gid, pid)
        oid = game["opponent"]["player_id"]
        if oid do
          {:ok, updates} = GameAgent.get_player_game(gid, oid)
          Battleship.Endpoint.broadcast!("#{gid}' game has been updated successfully: ship placed")
        end
        {:reply, {:ok, game}, socket}
      {:error, reason} ->
        {:reply, {:error, reason}, socket}
    end
  end

  #to make a guess
  def handle_in("guess", %{"x" => x, "y" => y}, socket) do
    gid = socket.assigns[:game_id]
    pid = socket.assigns[:player_id]
    case GameAgent.player_guess(gid, pid, x: x, y: y) do
      {:ok, _} ->
        {:ok, game} = GameAgent.get_player_game(gid, pid)
        oid = game["opponent"]["player_id"]
        if oid do
          {:ok, updates} = GameAgent.get_player_game(gid, oid)
          Battleship.Endpoint.broadcast!("#{gid}' game has been updated successfully: guess made")
        end
        {:reply, {:ok, game}, socket}
      {:error, reason} ->
        {:reply, {:error, reason}, socket}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  # def handle_in("ping", payload, socket) do
  #   {:reply, {:ok, payload}, socket}
  # end
  #
  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (game_room:lobby).
  # def handle_in("shout", payload, socket) do
  #   broadcast socket, "shout", payload
  #   {:noreply, socket}
  # end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
