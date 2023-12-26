
defmodule Util do
  def gcd(a, b) when a < b do
    gcd(b, a)
  end

  def gcd(a, b) when rem(a, b) == 0  do
    b
  end

  def gcd(a, b) do
    gcd(b, rem(a, b))
  end

  def lcm(a, b) do
    div(a * b, gcd(a, b))
  end
end

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

nodes
|> Map.keys()
|> Enum.filter(&(Regex.match?(~r/^\w\wA$/, &1)))
|> Enum.map(fn startingNode ->
  instructionStream
  |> Enum.reduce_while({startingNode, 0}, fn op, {cur, cnt} ->
    if Regex.match?(~r/^\w\wZ$/, cur) do
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
end)
|> Enum.reduce(1, &Util.lcm/2)
|> IO.puts()
