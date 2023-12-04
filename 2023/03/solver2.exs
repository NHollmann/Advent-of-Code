defmodule Util2 do
  def getImportantLines(lines, nr) do
    inputs = [
      {nr > 0, -1},
      {true, 0},
      {nr < length(lines) - 1, 1},
    ]
    Enum.reduce(inputs, [], fn {true, offset}, result ->
      [Enum.at(lines, nr + offset) | result]
    end)
  end
end

Code.require_file("util.exs")

{:ok, contents} = File.read("input.txt")
lines = String.split(contents, "\n", trim: true)

lines
|> Enum.with_index
|> Enum.flat_map(fn {line, nr} ->
  Regex.scan(~r/\*/, line, return: :index)
  |> Enum.map(fn [{start, len}] ->
    neighbors = Util.getNeighborsList(lines, nr, start, len)
    count = neighbors
    |> Enum.map(fn row -> Regex.scan(~r/\d+/, row) |> length end)
    |> Enum.sum

    {nr, start, count}
  end)
end)
|> Enum.filter(fn {_, _, count} -> count == 2 end)
|> Enum.map(fn {row, col, _} ->
  Util2.getImportantLines(lines, row)
  |> Enum.flat_map(fn subline ->
    Regex.scan(~r/\d+/, subline, return: :index)
    |> Enum.map(fn [res] -> res end)
    |> Enum.filter(fn {start, len} ->
      {start, len} = Util.expandRange(lines, start, len)
      col >= start and col <= start + len - 1
    end)
    |> Enum.map(fn {start, len} -> String.slice(subline, start, len) |> String.to_integer end)
  end)
  |> Enum.reduce(1, fn new, product -> new * product end)
end)
|> Enum.sum
|> IO.puts
