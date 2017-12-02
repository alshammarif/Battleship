defmodule Battleship.Game do
  alias Battleship.Game.Player
  alias Battleship.Game.Board
  alias Battleship.Game

  ##Game should keep track of:
  # players in game, new table, challenges, player, winner, boards

  # defstruct ["id", "player1", "player2"]

  def new(id) do
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

    oboard = if opponent == nil, do: Board.new, else: opponent["board"]
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

  end

  def place(game, pid, posn) do
    #place ship on game board
  end

end
