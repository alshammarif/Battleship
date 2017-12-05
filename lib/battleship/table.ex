defmodule BattleShip.Table do
  alias BattleShip.Game
  alias BattleShip.Game.Player
  alias BattleShip.Table.User


  @chars "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" |> String.split("", trim: true)

  defp string_of_length(length) do
    Enum.reduce((1..length), [], fn (_i, acc) ->
      [Enum.random(@chars) | acc]
    end) |> Enum.join("")
  end

  def createGame() do
    tableID = string_of_length(3)
    game = Game.new()
    %{"kind" => "Table", "id" => tableID, "game" => game}
  end

  def createUser(username,table) do
    code = string_of_length(2)
    game = table["game"]
    player = Player.new(code)
    game =  Game.add_player(game, player)

    user = %{"kind" => "User", "username" => username, "id" => code, "player" => player}

    %{table | "game" => game, "user" => user}
  end

end
