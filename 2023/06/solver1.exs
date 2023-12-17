
{:ok, contents} = File.read("input.txt")

[_, timesStr] = Regex.run(~r/^Time:\s+([0-9 ]+)$/m, contents)
[_, distsStr] = Regex.run(~r/^Distance:\s+([0-9 ]+)$/m, contents)

times = String.split(timesStr, " ", trim: true) |> Enum.map(&String.to_integer/1)
dists = String.split(distsStr, " ", trim: true) |> Enum.map(&String.to_integer/1)

# f(x) = (t - x) * x = -x^2  + tx
# f(x) - d = -x^2 + tx -d != 0
# p/q - Formel:
#            x^2 - tx + d != 0
#    p = -t
#    q = d

Enum.zip(times, dists)
|> Enum.map(fn {t, d} ->

  termLeft = t/2.0
  termRight = :math.sqrt((-t/2.0)**2 - d)
  leftBorder = floor(termLeft - termRight)
  rightBorder = ceil(termLeft + termRight) - 1

  rightBorder - leftBorder
end)
|> Enum.product
|> IO.puts
