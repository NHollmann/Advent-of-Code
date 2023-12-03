
Code.require_file("util.exs")

{:ok, contents} = File.read("input.txt")
lines = String.split(contents, "\n", trim: true)

lines
|> Enum.with_index
|> Enum.flat_map(fn {line, nr} ->
  Regex.scan(~r/\d+/, line, return: :index)
  |> Enum.map(fn [{start, len}] ->
    number = String.slice(line, start, len) |> String.to_integer
    neighbors = Util.getNeighbors(lines, nr, start, len)
    {number, neighbors}
  end)
end)
|> Enum.filter(fn {_, neighbors} -> Regex.match?(~r/[^0-9\.]/, neighbors) end)
|> Enum.map(fn {number, _} -> number end)
|> Enum.sum
|> IO.puts
