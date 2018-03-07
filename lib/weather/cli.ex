defmodule Weather.Cli do
  import SweetXml

  @moduledoc """
  Handle the command line parsing and the dispatch to the 
  various functions that end up generating a table of the 
  last _n_ issues in a github project
  """

  def main(argv) do
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
    |> decode_response
    |> format
    |> IO.puts()
  end

  def format(response) do
    location = response |> xpath(~x"//location/text()")
    weather = response |> xpath(~x"//weather/text()")
    temperature = response |> xpath(~x"//temperature_string/text()")
    wind_string = response |> xpath(~x"//wind_string/text()")
    windchill_f = response |> xpath(~x"//windchill_f/text()")
    visibility = response |> xpath(~x"//visibility_mi/text()")

    IO.puts(weather_ascii())

    IO.puts("""

    The current weather for #{location} is #{weather}.

    Temperature: #{temperature}
    Wind: #{wind_string}
    Wind chill: #{windchill_f} (F)
    Visibility: #{visibility} miles

    """)

    System.halt(0)
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts("Error fetching from NWS: #{error}")
    System.halt(2)
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

  def weather_ascii do
    """
                          _   _
                         | | | |
      __      _____  __ _| |_| |__   ___ _ __
      \ \ /\ / / _ \/ _` | __| '_ \ / _ \ '__|
       \ V  V /  __/ (_| | |_| | | |  __/ |
        \_/\_/ \___|\__,_|\__|_| |_|\___|_|
    """
  end
end
