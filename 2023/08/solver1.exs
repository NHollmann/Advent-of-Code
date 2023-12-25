
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

instructionStream
|> Enum.reduce_while({"AAA", 0}, fn op, {cur, cnt} ->
  if cur == "ZZZ" do
    {:halt, cnt}
  else
    {l, r} = Map.get(nodes, cur)
    if op == "L" do
      {:cont, {l, cnt + 1}}
    else
      {:cont, {r, cnt + 1}}
    end
  end
end)
|> IO.puts()
