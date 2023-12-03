
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
   # TODO
end)
|> IO.inspect
#|> Enum.sum
#|> IO.puts
