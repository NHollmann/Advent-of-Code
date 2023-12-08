
File.stream!("input.txt")
|> Stream.map(&String.trim/1)
|> Stream.map(fn line ->
  [_, card, winning, myNumbers] = Regex.run(~r/^Card\s+(\d+): ([0-9 ]+) \| ([0-9 ]+)$/, line)
  cardNr = String.to_integer card
  winningSet = String.split(winning, " ", trim: true) |> Enum.map(&String.to_integer/1) |> MapSet.new
  myNumberSet = String.split(myNumbers, " ", trim: true) |> Enum.map(&String.to_integer/1) |> MapSet.new
  winningCount = MapSet.intersection(winningSet, myNumberSet) |> MapSet.size
  {cardNr, winningCount}
  end)
|> Enum.reduce(%{}, fn {cardNr, winningCount}, cards ->
  cards = Map.update(cards, cardNr, 1, fn x -> x + 1 end)
  count = cards[cardNr]
  if winningCount > 0 do
    Enum.reduce(Enum.to_list(1..winningCount), cards, fn x, cards ->
      Map.update(cards, cardNr + x, count, fn x -> x + count end)
    end)
  else
    cards
  end
end)
|> Map.values
|> Enum.sum()
|> IO.puts
