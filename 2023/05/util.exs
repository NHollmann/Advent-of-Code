
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

  def map_range(mr, xs) do
    first = mr.source_start
    last = mr.source_start + mr.range_length
    if xs != nil and xs.first >= first and xs.first < last and xs.last >= first and xs.last < last do
      first = xs.first - mr.source_start + mr.destination_start
      last = xs.last - mr.source_start + mr.destination_start
      first..last
    else
      nil
    end
  end

  def cut_range(mr, xs) do
    first = mr.source_start
    last = mr.source_start + mr.range_length
    cond do
      xs.first < first and xs.last >= first and xs.last < last -> {xs.first..first - 1, first..xs.last, nil}
      xs.first >= first and xs.first < last and xs.last >= last -> {nil, xs.first..last - 1, last..xs.last}
      xs.first < first and xs.last >= last -> {xs.first..first - 1, first..last - 1, last..xs.last}
      xs.last < first -> {xs, nil, nil}
      xs.first >= last -> {nil, nil, xs}
      true -> {nil, xs, nil}
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
    r = Enum.sort(r, fn x, y -> x.source_start < y.source_start end)
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

  def map_range(fm, xs) do
    [mr | mrs] = fm.ranges
    {l, m, r} = MappingRange.cut_range(mr, xs)
    m = MappingRange.map_range(mr, m)
    r = if r != nil do
      if mrs != [] do
        map_range(%FullMapping{ranges: mrs}, r)
      else
        [r]
      end
    else
      []
    end

    [l, m | r]
    |> Enum.filter(&(&1 != nil))
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

  def map_range(mc, xs) do
    Enum.reduce(mc.mappings, [xs], fn m, y ->
      Enum.flat_map(y, fn z ->
        FullMapping.map_range(m, z)
      end)
    end)
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

defmodule SeedLocator do
  def find_nearest(mc, seeds) do
    seeds
    |> Enum.map(fn seed -> MappingChain.map(mc, seed) end)
    |> Enum.min
  end

  def find_nearest_range(mc, seeds) do
    MappingChain.map_range(mc, seeds)
    |> Enum.reduce(:infinity, fn r, acc ->
      if r.first < acc do r.first else acc end
    end)
  end
end
