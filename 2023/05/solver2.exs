
Code.require_file("util.exs")


{:ok, contents} = File.read("input.txt")
lines = String.split(contents, "\n", trim: true)
[seedStr | lines] = lines
[_ | lines] = lines

mc = MappingChain.parse(lines)

[_, seedStr] = Regex.run(~r/^seeds: ([0-9 ]+)$/, seedStr)
seeds = String.split(seedStr, " ", trim: true) |> Enum.map(&String.to_integer/1)
seedRangeCount = div(length(seeds), 2) - 1

Enum.map(0..seedRangeCount, fn idx ->
  start = Enum.at(seeds, idx * 2)
  len = Enum.at(seeds, idx * 2 + 1)
  start..(start + len - 1)
end)
|> Enum.map(fn r -> SeedLocator.find_nearest_range(mc, r) end)
|> Enum.min
|> IO.puts
