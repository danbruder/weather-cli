defmodule WeatherCliTest do
  use ExUnit.Case
  doctest Weather

  import Weather.Cli, only: [parse_args: 1]

  test ":help returned when parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "one val returned if one given" do
    assert parse_args(["anything"]) == "anything"
  end
end
