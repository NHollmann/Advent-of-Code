
{:ok, contents} = File.read("input.txt")

[_, timesStr] = Regex.run(~r/^Time:\s+([0-9 ]+)$/m, contents)
[_, distsStr] = Regex.run(~r/^Distance:\s+([0-9 ]+)$/m, contents)

t = String.replace(timesStr, " ", "") |> String.to_integer
d = String.replace(distsStr, " ", "") |> String.to_integer

# f(x) = (t - x) * x = -x^2  + tx
# f(x) - d = -x^2 + tx -d != 0
# p/q - Formel:
#            x^2 - tx + d != 0
#    p = -t
#    q = d

termLeft = t/2.0
termRight = :math.sqrt((-t/2.0)**2 - d)
leftBorder = floor(termLeft - termRight)
rightBorder = ceil(termLeft + termRight) - 1

IO.puts(rightBorder - leftBorder)
