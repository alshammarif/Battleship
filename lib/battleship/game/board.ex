defmodule Battleship.Game.Board do
  alias Battleship.Game.Ship
  alias Battleship.Game.Posn
  alias Battleship.Game.Board
  # Game Board should keep track of: owner, game, opponent, hit, sink,
  # miss, unplaced and placed ships, and ship location
  @ships_sizes [5, 4, 3, 3, 2]
  @size 10
  @orientation [:horizontal, :vertical]

  @hit "*"
  @ship "/"
  @water "~"
  @miss "-"

  def ships_sizes, do: @ships_sizes
  def size, do: @size

  defstruct [
    :player_id,
    :ready,
    :unplaced,
    :placed,
    :miss,
    :hits
  ]

  def create(player_id) do
    unplaced_ships = Enum.map(@ships_sizes, fn(size) ->
      {:ok, ship} = Ship.new(size)
      ship
    end)

    %{"kind" => "Board",
    "ready" => false,
    "unplaced" => unplaced_ships,
    "placed" => [],
    "miss" => MapSet.new,
    "hits" => MapSet.new
    }

    # %Board{
    #   player_id: player_id,
    #   ready: false,
    #   unplaced: unplaced_ships,
    #   placed: [],
    #   miss: MapSet.new,
    #   hits: MapSet.new
    # }
  end

  def add_ship(board, ship, x, y) do
    if ship != nil do
      index = Enum.find_index(board["unplaced"], fn(s) -> s["size"] == ship["size"] end)
      #check if not duplicate
      if duplicate?(board, ship["size"]) do
        { :error, "already placed"}
      end
      #check if on board (position is within the bounds)
      if outbounds(ship["size"], x) or outbounds(ship["size"], y) do
        { :error, "ship out of bounds"}
      end
      #check if there is overlap with other ships_sizes
      case Ship.place(ship, x, y) do
        {:ok, ship} ->
          if Enum.any?(board["placed"], fn(s) -> Ship.overlap?(s, ship) end) do
            {:error, "overlapping ships"}
          else
            newunp = List.delete_at(board["unplaced"], index)
            newpl = Enum.concat(board["placed"], [ship])
            if Enum.empty?(newunp) do
              {:ok, %{board | "unplaced" => newunp, "placed" => newpl, "ready" => true}}
            else
              {:ok, %{board | "unplaced" => newunp, "placed" => newpl}}
            end
          end
        {:error, reason} ->
          {:error, reason}
      end
    else
      {:error, "invalid ship"}
    end
  end

  def guess(board, x, y) do
    if Enum.any?(board["placed"], fn(s) -> Ship.hit?(s, x, y) end) do
      newplaced = Enum.each(board["placed"], fn(s) -> Ship.hit(s, x, y) end)
      posn = Posn.new(x,y)
      hits = MapSet.put(board["hits"], posn)
      {:ok, %{board | "hits" => hits, "placed" => newplaced}}
    else
      posn = Posn.new(x,y)
      miss = MapSet.put(board["miss"], posn)
      {:ok, %{board | "miss" => miss}}
    end
    #check if guess hit a ship (the position is within a ship location) => add to hits, change ship to be 'hit' mapset.put(hits, postion)
    #add position to miss and change the position MapSet.put(hits, position)
  end

  def duplicate?(board, size) do
    permitted_amnt = Enum.count(@ships_sizes, &(&1 == size))
    Enum.count(board["placed"], &(&1["size"] == size)) == permitted_amnt
  end

  def outbounds(size, coord) do
    size + coord > @size - 1 or coord < 0 or coord > @size - 1
  end

  def opponent_board(board) do
    %{"ready" => board["ready"],
    "board-grid" => view_board(board, false)
    }
  end

  def own_board(board, pid) do
    %{"player_id" => pid,
      "ready" => board["ready"],
      "board-grid" => view_board(board, true)
    }
  end

  defp view_board(board, owner) do
    grid = Enum.concat[0..@size - 1]
    Enum.map(grid, fn(x) ->
      Enum.map(grid, fn(y) ->
        si = Enum.find_index(board["placed"], fn(s) -> Ship.location?(s, x, y) end)
        posn = Posn.new(x,y)
        cond do
          si == nil and Mapset.member?(board["miss"], posn) ->
            @miss
          si != nil and Mapset.member?(board["hits"], posn) ->
            @hit
          si != nil and owner ->
            @ship
          true ->
            @water
        end
      end)
    end)
  end

  def over?(board) do
    Enum.count(board["placed"], fn(s) -> Ship.sunk(s) end) == Enum.count(board["placed"])
  end



end
