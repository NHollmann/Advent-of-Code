
Code.require_file("util.exs")

defmodule SeedLocator do
  def findNearest(mc, seeds) do
    seeds
    |> Enum.map(fn seed -> MappingChain.map(mc, seed) end)
    |> Enum.min
  end
end


{:ok, contents} = File.read("input.txt")
lines = String.split(contents, "\n", trim: true)
[seedStr | lines] = lines
[_ | lines] = lines

[_, seedStr] = Regex.run(~r/^seeds: ([0-9 ]+)$/, seedStr)
seeds = String.split(seedStr, " ", trim: true) |> Enum.map(&String.to_integer/1)

lines
|> MappingChain.parse
|> SeedLocator.findNearest(seeds)
|> IO.puts
