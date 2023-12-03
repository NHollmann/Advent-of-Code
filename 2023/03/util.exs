
defmodule Util do
  def getNeighbors(lines, nr, start, len) do
    Enum.join(getNeighborsList(lines, nr, start, len))
  end

  def getNeighborsList(lines, nr, start, len) do
    {start, len} = expandRange(lines, start, len)
    [
      getTopNeighbors(lines, nr, start, len),
      getCurNeighbors(lines, nr, start, len),
      getBottomNeighbors(lines, nr, start, len)
    ]
  end

  defp getTopNeighbors(lines, nr, start, len) do
    if nr == 0 do
      ""
    else
      String.slice(Enum.at(lines, nr - 1), start, len)
    end
  end

  defp getCurNeighbors(lines, nr, start, len) do
    String.slice(Enum.at(lines, nr), start, len)
  end

  defp getBottomNeighbors(lines, nr, start, len) do
    if nr == length(lines) - 1 do
      ""
    else
      String.slice(Enum.at(lines, nr + 1), start, len)
    end
  end

  defp expandRange(lines, start, len) do
    maxLen = lines
    |> Enum.at(0)
    |> String.length

    {start, len} = if start > 0 do {start - 1, len + 1} else {start, len} end
    {start, len} = if start + len < maxLen - 1 do {start, len + 1} else {start, len} end

    {start, len}
  end
end
