defmodule Weather.Cli do
  @moduledoc """
  Handle the command line parsing and the dispatch to the 
  various functions that end up generating a table of the 
  last _n_ issues in a github project
  """

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  def process(:help) do
    IO.puts("""
    usage:  weather <slug>
    """)

    System.halt(0)
  end

  def process(slug) do
    Weather.NWS.fetch(slug)
  end

  @doc """
  `argb` can be -h or --help, which returns :help.

  Otherwise it is the slug corresponding to the weather.gov
  current conditions service. For example, for the weather in
  Denton Enterprise Airport, TX, use "KDTO"
  """
  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> args_to_internal_representation
  end

  def args_to_internal_representation({[help: true], _, _}) do
    :help
  end

  def args_to_internal_representation({_, [slug], _}) do
    slug
  end

  def args_to_internal_representation(_) do
    :help
  end
end
