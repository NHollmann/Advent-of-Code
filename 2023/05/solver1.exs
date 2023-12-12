
Code.require_file("util.exs")

{:ok, contents} = File.read("input.txt")
lines = String.split(contents, "\n", trim: true)
[seedStr | lines] = lines
[_ | lines] = lines

[_, seedStr] = Regex.run(~r/^seeds: ([0-9 ]+)$/, seedStr)
seeds = String.split(seedStr, " ", trim: true) |> Enum.map(&String.to_integer/1)

lines
|> MappingChain.parse
|> SeedLocator.find_nearest(seeds)
|> IO.puts
