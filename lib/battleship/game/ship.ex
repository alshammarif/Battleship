defmodule Battleship.Game.Ship do
  alias Battleship.Game.Board
  alias Battleship.Game.Player
  alias Battleship.Game.Posn
  alias Battleship.Game.Ship

  ##horizontal or vertical, hits, sunk, position

  defstruct [
    :size,
    :orientation,
    :first,
    :members,
    :hits,
  ]

  def new(size) do
    if Enum.member?(Board.ships_sizes, size) do
      %{"kind" => "ship",
      "size" => size,
      "orientation" => "horizontal",
      "sunk" => false,
      "hits" => 0
      }
    # %Ship {
    #   size: size,
    #   orientation: "horizontal",
    #   hits: 0
    # }
    else
      { :error, "Invalid Size"}
    end
  end

  def changeORN(ship) do
    if ship["orientation"] == "horizontal" do
      %{ship | "orientation" => "vertical"}
    else
      %{ship | "orientation" => "horizontal"}
    end
  end

  def hit(ship, hx, hy) do
    if !sunk(ship) do
      posn = Enum.find(ship["members"],
       fn(m) -> m["x"] == hx and m["y"] == hy end)
      if posn != nil do
        if !posn["hit"] do
          newp = Posn.hit(posn)
          newm = Enum.concat(ship["members"], [newp])
          newm = Enum.drop_while(ship["members"], fn(m) -> m == posn end)
          if(ship["orientation"] == "horizontal") do
            newm = Enum.sort(ship["members"], fn(n,p) -> n["x"] < p["x"] end)
            %{ship | "hits" => ship["hits"] +1, "members" => newm}
          else
            newm = Enum.sort(ship["members"], fn(n,p) -> n["y"] < p["y"] end)
            %{ship | "hits" => ship["hits"] + 1, "members" => newm}
          end
        end
      else
        ship
      end
    else
      { :error, "already sunk!"}
    end
  end

  def hit?(ship, x, y) do
    Enum.any?(ship["members"], fn(m) ->
      m["x"] == x and m["y"] == y and m["hit"]
    end)
  end

  def location?(ship, x, y) do
    Enum.any?(ship["members"], fn(p) -> p["x"] == x and p["y"] == y end)
  end

  def sunk(ship) do
    ship["size"] == ship["hits"]
  end

  def overlap?(ship1, ship2) do
    Enum.any?(ship1.members, fn(m) ->
      Enum.any?(ship2.members, fn(m1) -> m1.x == m.x && m1.y == m.y end) end)
  end

  def place(ship, x, y) do
    first = Posn.new(x, y)
    if ship.orientation == "horizontal" do
      sx = ship.size - 1 + x
      pieces = Enum.concat([x..sx])
      members = Enum.map(pieces, fn(p) ->
        {:ok, posn} = Posn.new(p, y)
        posn
      end)
      %{ ship | first: first, members: members}
    end
    if ship.orientation == "vertical" do
      sy = ship.size - 1 + y
      pieces = Enum.concat([y..sy])
      members = Enum.map(pieces, fn(p) ->
        {:ok, posn} = Posn.new(x, p)
        posn
      end)
      %{ ship | first: first, members: members}
    else
      {:error, "invalid orientation"}
    end
  end
end
