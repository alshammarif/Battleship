defmodule Battleship.Game do
  alias Battleship.Game.Player
  alias Battleship.Game.Board
  alias Battleship.Game

  ##Game should keep track of:
  # players in game, new table, challenges, player, winner, boards

  # defstruct ["id", "player1", "player2"]
  @chars "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" |> String.split("", trim: true)

  def string_of_length(length) do
    Enum.reduce((1..length), [], fn (_i, acc) ->
      [Enum.random(@chars) | acc]
    end) |> Enum.join("")
  end

  def new() do
    id = string_of_length(5)
    %{"kind" => "Game", "game_id" => id, "player1" => nil, "player2" => nil}
  end

  def add_player(game, player) do
    cond do
      game["player1"] and game["player2"] ->
        {:error, "full game kiddo"}
      game["player1"] ->
        %{game | "player2" => player}
      true ->
        %{game | "player1" => player}
    end
  end

  def view_for_player(game, pid) do
    thisplayer = getplayer(game, pid)
    opponent = getopponent(game, pid)

    oboard = if opponent == nil, do: Board.create, else: opponent["board"]
    oid = if opponent == nil, do: nil, else: opponent["player_id"]

    %{
      "game_id" => game["game_id"],
      "player_id" => pid,
      "opponent" => Board.opponent_board(oboard, oid),
      "player_board" => Board.own_board(thisplayer["board"], pid)
    }
  end


  defp getplayer(game, pid) do
    cond do
      game["player1"] != nil and pid == game["player1"]["player_id"] ->
        game["player1"]
      game["player2"] != nil  and pid == game["player2"]["player_id"] ->
        game["player2"]
      true ->
        nil
    end
  end

  defp getopponent(game, pid) do
    if game["player1"] != nil and game["player2"] != nil do
      cond do
        game["player1"]["player_id"] == pid ->
          game["player2"]
        true ->
          game["player1"]
      end
    else
      nil
    end
  end

  def gameover?(game) do
    p1board = game["player1"]["board"]
    p2board = game["player2"]["board"]

    Board.over?(p1board) or Board.over?(p2board)
  end

  def guess(game, pid, posn) do
    #guess opponent if their turn also see opponent guesses
    player = getplayer(game, pid)
    if player["turn"] do
      opponent = getopponent(game, pid)
      oboard = opponent["board"]
      {result, board} = Board.guess(oboard, posn["x"], posn["y"])
      if result != :error do
        opponent = Player.turn(opponent)
        opponent = %{opponent | "board" => board}
        game = Map.put(game, okey(game,pid), opponent)

        player = Player.turnFinish(player)
        game = Map.put(game, pkey(game,pid), player)
      end

      {result, game}
    else
      {:error, "other player's turn"}
    end

  end

  defp okey(game, pid) do
    if game["player1"] != nil and game["player2"] != nil do
      cond do
        game["player1"]["player_id"] == pid ->
          "player2"
        game["player2"]["player_id"] == pid ->
          "player1"
        true ->
          nil
        end
    else
      nil
    end
  end

  defp pkey(game, pid) do
    if game["player1"] != nil and game["player2"] != nil do
      cond do
        game["player1"]["player_id"] == pid ->
          "player1"
        game["player2"]["player_id"] == pid ->
          "player2"
        true ->
          nil
        end
    else
      nil
    end
  end

  def place(game, pid, size, posn) do
    #place ship on game board
    player = getplayer(game, pid)
    pboard = player["board"]
    case Board.add_ship(pboard, size, posn["x"], posn["y"]) do
      {:ok, board} ->
        player = %{player | "board" => board}
        game = Map.put(game, pkey(game, pid), player)
        {:ok, game}
      {:error, reason} ->
        {:error, reason}
    end

  end

end
