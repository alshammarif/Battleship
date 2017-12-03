defmodule Battleship.Game.Player do
  alias Battleship.Game.Board
  alias Battleship.Game
  alias Battleship.Game.Player

  #should keep track of game, moves, turn, board, opponent board, player guesses
  defstruct [
    :player_id,
    :board,
    :turn
  ]

  def new(pid) do
    %{"kind" => "Player",
    "player_id" => pid,
    "board" => Board.create,
    "turn" => false
    }
    # %Player {
    #   player_id: pid,
    #   board: Board.new(pid),
    #   turn: false
    # }
  end

  def turn(player) do
    %{ player | "turn" => true }
  end

  def turnFinish(player) do
    %{player | "turn" => false}
  end
end
