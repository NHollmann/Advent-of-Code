
numbers = %{
  "one" => "o1",
  "two" => "2",
  "three" => "3",
  "four" => "4",
  "five" => "5",
  "six" => "6",
  "seven" => "7",
  "eight" => "e8t",
  "nine" => "n9",
}

File.stream!("input.txt")
|> Stream.map(&String.trim/1)
|> Stream.map(fn
    (line) ->
      line = numbers
      |> Map.keys()
      |> Enum.reduce(line, fn key, str -> String.replace(str, key, numbers[key]) end)
      [_, first] = Regex.run(~r/^[[:alpha:]]*(\d)/i, line)
      [_, second] = Regex.run(~r/(\d)[[:alpha:]]*$/i, line)
      String.to_integer("#{first}#{second}")
  end)
|> Enum.sum()
|> IO.puts
