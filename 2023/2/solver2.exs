
defmodule Util do
  def maxOfColor(input, name) do
    Regex.scan(~r/(\d+) #{name}/, input)
    |> Enum.map(fn ([_, val]) -> String.to_integer(val) end)
    |> Enum.max()
  end
end

File.stream!("input.txt")
|> Stream.map(&String.trim/1)
|> Stream.map(fn
    (line) ->
      red = Util.maxOfColor(line, "red")
      green = Util.maxOfColor(line, "green")
      blue = Util.maxOfColor(line, "blue")
      red * green * blue
  end)
|> Enum.sum()
|> IO.puts
