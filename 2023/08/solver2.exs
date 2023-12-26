
{:ok, contents} = File.read("input.txt")
lines = String.split(contents, "\n", trim: true)

[instructions | nodeStrings] = lines

instructionStream = instructions
|> String.graphemes()
|> Stream.cycle()

nodes = nodeStrings
|> Enum.map(fn line ->
  [_, key, left, right] = Regex.run(~r/^(\w+) = \((\w+), (\w+)\)$/i, line)
  {key, {left, right}}
end)
|> Map.new()

startingNodes = nodes
|> Map.keys()
|> Enum.filter(&(Regex.match?(~r/^\w\wA$/, &1)))

instructionStream
|> Enum.reduce_while({startingNodes, 0}, fn op, {cur, cnt} ->
  done = cur
  |> Enum.map(&(Regex.match?(~r/^\w\wZ$/, &1)))
  |> Enum.all?()

  if done do
    {:halt, cnt}
  else
    {l, r} = cur
    |> Enum.map(&(Map.get(nodes, &1)))
    |> Enum.unzip()

    if op == "L" do
      {:cont, {l, cnt + 1}}
    else
      {:cont, {r, cnt + 1}}
    end
  end
end)
|> IO.puts()
