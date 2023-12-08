
File.stream!("input.txt")
|> Stream.map(&String.trim/1)
|> Stream.map(fn
    (line) ->
      [_, winning, myNumbers] = Regex.run(~r/^Card\s+\d+: ([0-9 ]+) \| ([0-9 ]+)$/, line)
      winningSet = String.split(winning, " ", trim: true) |> Enum.map(&String.to_integer/1) |> MapSet.new
      myNumberSet = String.split(myNumbers, " ", trim: true) |> Enum.map(&String.to_integer/1) |> MapSet.new
      MapSet.intersection(winningSet, myNumberSet)
      |> MapSet.size
  end)
|> Enum.filter(fn cnt -> cnt > 0 end)
|> Enum.map(fn cnt -> 2 ** (cnt - 1) end)
|> Enum.sum()
|> IO.puts
