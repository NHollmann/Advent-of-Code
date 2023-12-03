
defmodule Util do
  def isImpossible?(input, name, max) do
    Regex.scan(~r/(\d+) #{name}/, input)
    |> Enum.map(fn ([_, val]) -> String.to_integer(val) > max end)
    |> Enum.reduce(false, fn i, acc -> acc or i end)
  end
end

File.stream!("input.txt")
|> Stream.map(&String.trim/1)
|> Stream.map(fn
    (line) ->
      [_, gameId] = Regex.run(~r/^Game (\d+):/, line)
      gameId = String.to_integer("#{gameId}")

      gameId = if Util.isImpossible?(line, "red", 12) or
                  Util.isImpossible?(line, "green", 13) or
                  Util.isImpossible?(line, "blue", 14) do
        0
      else
        gameId
      end

      gameId
  end)
|> Enum.sum()
|> IO.puts
