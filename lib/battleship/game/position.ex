defmodule Battleship.Game.Posn do
  alias Battleship.Game.Ship
  alias Battleship.Game.Board
  alias Battleship.Game.Posn

  @coords ["x", "y"]
  defstruct [
    :x,
    :y,
    :hit
  ]

  def new(x, y) do
    %{"kind" => "Posn", "x" => x, "y" => y, "hit" => false}
    # %Posn{x: x, y: y, hit: false}
  end

  def hit(posn) do
    if !posn["hit"]do
      %{posn | "hit" => true}
    end
  end

end

## { "kind"  => "Posn", "x" => 5}
