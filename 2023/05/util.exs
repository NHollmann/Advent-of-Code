
defmodule MappingRange do
  defstruct [
    source_start: 0,
    destination_start: 0,
    range_length: 0
  ]

  def new(src, dest, len) do
    %MappingRange{source_start: src, destination_start: dest, range_length: len}
  end

  def map(mr, x) do
    if x >= mr.source_start and x < mr.source_start + mr.range_length do
      x - mr.source_start + mr.destination_start
    else
      nil
    end
  end

  def parse(line) do
    res = Regex.run(~r/^(\d+) (\d+) (\d+)$/, line)
    if res == nil do
      nil
    else
      [_, dest, src, len] = res
      new(
        String.to_integer(src),
        String.to_integer(dest),
        String.to_integer(len)
      )
    end
  end
end

defmodule FullMapping do
  defstruct [
    ranges: []
  ]

  def new(r) do
    %FullMapping{ranges: r}
  end

  def map(fm, x) do
    Enum.reduce_while(fm.ranges, x, fn mr, acc ->
      res = MappingRange.map(mr, x)
      if res == nil do
        {:cont, acc}
      else
        {:halt, res}
      end
    end)
  end

  def parse(lines) do
    {ranges, lines} = parse_internal(lines)
    {new(ranges), lines}
  end

  defp parse_internal([]) do
    {[], []}
  end

  defp parse_internal([curLine | lines]) do
    res = MappingRange.parse(curLine)
    if res == nil do
      {[], lines}
    else
      {parseRes, lines} = parse_internal(lines)
      {[res | parseRes], lines}
    end
  end
end

defmodule MappingChain do
  defstruct [
    mappings: []
  ]

  def new(m) do
    %MappingChain{mappings: m}
  end

  def map(mc, x) do
    Enum.reduce(mc.mappings, x, &FullMapping.map/2)
  end

  def parse(lines) do
    parse_internal(lines)
    |> new
  end

  defp parse_internal(lines) do
    {mapping, lines} = FullMapping.parse(lines)
    if lines == [] do
      [mapping]
    else
      [mapping | parse_internal(lines)]
    end
  end
end
