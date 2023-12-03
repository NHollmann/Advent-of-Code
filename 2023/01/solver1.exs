
File.stream!("input.txt")
|> Stream.map(&String.trim/1)
|> Stream.map(fn
    (line) ->
      [_, first] = Regex.run(~r/^[[:alpha:]]*(\d)/i, line)
      [_, second] = Regex.run(~r/(\d)[[:alpha:]]*$/i, line)
      String.to_integer("#{first}#{second}")
  end)
|> Enum.sum()
|> IO.puts
