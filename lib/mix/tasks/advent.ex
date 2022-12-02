defmodule Mix.Tasks.Advent do
  use Mix.Task

  @shortdoc "Advent of Code"
  def run(args) do
    {parsedOptions, _} =
      OptionParser.parse!(args,
        aliases: [y: :year, d: :day, p: :part, b: :benchmark],
        strict: [year: :integer, day: :integer, benchmark: :boolean, part: :integer]
      )

    IO.inspect(parsedOptions)
    year = Keyword.get(parsedOptions, :year, nil)
    day = Keyword.get(parsedOptions, :day, 1)
    benchmark = Keyword.get(parsedOptions, :benchmark, false)
    part = Keyword.get(parsedOptions, :part, 1)

    input = AdventOfCode.Input.get!(day, year)

    module =
      Module.concat(AdventOfCode, "Day#{String.pad_leading(Integer.to_string(day), 2, "0")}")

    if benchmark do
      Benchee.run(%{
        "#{year}_#{day_string}_part_#{part}": fn -> apply(module, :"part#{part}", [input]) end
      })
    else
      apply(module, :"part#{part}", [input])
      |> IO.inspect(label: "#{year} #{day_string} Part #{part} Results")
    end
  end
end
