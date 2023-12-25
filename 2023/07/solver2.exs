
defmodule Hand do
  @five_of_kind  6
  @four_of_kind  5
  @full_house    4
  @three_of_kind 3
  @two_pairs     2
  @one_pair      1
  @high_card     0

  @sortableLetters %{
    "T" => "a",
    "J" => "1",
    "Q" => "c",
    "K" => "d",
    "A" => "e",
  }

  defstruct [
    cards: "",
    sortableCards: "",
    bid: 0,
    type: 0,
  ]

  def parse(input) do
    [cards, bidStr] = String.split(input, " ")
    type = get_type(cards)

    sortCards = @sortableLetters
    |> Map.keys()
    |> Enum.reduce(cards, fn key, str -> String.replace(str, key, @sortableLetters[key]) end)

    %Hand{
      cards: cards,
      sortableCards: sortCards,
      bid: String.to_integer(bidStr),
      type: type
    }
  end

  defp get_type(cards) do
    freqs = cards
    |> String.graphemes()
    |> Enum.frequencies()

    jCount = Map.get(freqs, "J", 0)
    freqs = Map.delete(freqs, "J")

    {maxKey, maxVal} = freqs
    |> Enum.reduce({"A", 0}, fn {key, val}, {maxKey, maxVal} ->
      if val > maxVal do
        {key, val}
      else
        {maxKey, maxVal}
      end
    end)

    freqs = Map.put(freqs, maxKey, maxVal + jCount)
    freqCnt = map_size(freqs)

    cond do
      freqCnt == 1 -> @five_of_kind
      freqCnt == 2 && Enum.member?(Map.values(freqs), 4) -> @four_of_kind
      freqCnt == 2 && Enum.member?(Map.values(freqs), 3) -> @full_house
      freqCnt == 3 && Enum.member?(Map.values(freqs), 3) -> @three_of_kind
      freqCnt == 3 && Enum.member?(Map.values(freqs), 2) -> @two_pairs
      freqCnt == 4 -> @one_pair
      freqCnt == 5 -> @high_card
      true -> -1
    end
  end

  def compare(handA, handB) do
    cond do
      handA.type < handB.type -> true
      handA.type > handB.type -> false
      handA.type == handB.type -> handA.sortableCards <= handB.sortableCards
    end
  end
end


{:ok, contents} = File.read("input.txt")
lines = String.split(contents, "\n", trim: true)

lines
|> Enum.map(fn line -> Hand.parse(line) end)
|> Enum.sort(&Hand.compare/2)
|> Enum.with_index(1)
|> Enum.map(fn {e, rank} -> e.bid * rank end)
|> Enum.sum()
|> IO.puts()
