defmodule Battleship.GameAgent do
  use GenServer
  alias Battleship.GameAgent
  alias Battleship.Game
  alias Battleship.Game.Player
  alias Battleship.Game.Posn

  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, state, name:__MODULE__)
  end

  def create(game_id) do
    GenServer.call(__MODULE__, {:create, game_id})
  end

  def add_player(game_id, player_id) do
    GenServer.call(__MODULE__, {:add_player, game_id, player_id})
  end

  def place_ship(game_id, player_id, fx: fx, fy: fy) do
    GenServer.call(__MODULE__, {:place_ship, game_id, player_id, fx: fx, fy: fy})
  end

  def player_guess(game_id, player_id, x: x, y: y) do
    GenServer.call(__MODULE__, {:player_guess, game_id, player_id, x: x, y: y})
  end

  def get_player_game(game_id, player_id) do
    GenServer.call(__MODULE__, {:get_player_game, game_id, player_id})
  end

  def handle_call({:create, game_id}, _from, game_id) do
    game = Game.new(game_id)
    games = Map.put(games, game_id, game)
    {:reply, {:ok, game_id}, games}
  end

  def handle_call({:add_player, game_id, player_id}, _from, games) do
    game = Map.get(games, game_id)
    {result, game} = Game.add_player(game, Player.new(player_id))
    games = Map.put(games, game_id, game)
    {:reply, {result, Game.view_for_player(game, player_id)}, games}
  end

  def handle_call({:place_ship, game_id, player_id, fx: fx, fy: fy}, _from, games) do
    game = Map.get(games, game_id)

    case Posn.new(x, y) do
      {:ok, posn} ->
        case Game.place(game, player_id, posn) do
          {:ok, game} ->
            games = Map.put(games, game_id,   game)
            {:reply, {:ok, Game.view_for_player(game, player_id)}, games}
          {:error, reason} ->
            {:reply, {:error, reason}, games}
        end
      {:error, reason} ->
        {:reply, {:error, reason}, games}
    end
  end

  def handle_call({:player_guess, game_id, player_id, x: x, y: y}, _from, games) do
    game = Map.get(games, game_id)

    case Posn.new(x,y) do
      {:ok, guess} ->
        case Game.guess(game, player_id, guess) do
          {result, game} ->
            games = Map.put(games, game_id, game)
            {:reply, {:ok, Game.view_for_player(game, player_id)}, games}
          {:error, reason} ->
            {:reply, {:error, reason}, games}
        end
      {:error, reason} ->
        {:reply, {:error, reason}, games}
    end
  end

  def handle_call({:get_player_game, game_id, player_id}, _from, games) do
    game = Map.get(games, game_id)
    if game != nil do
      game = Game.view_for_player(game, player_id)
    end
    {:reply, {:ok, game}, games}
  end

  def init(state) do: {:ok, state}


end
