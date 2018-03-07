defmodule Weather.NWS do
  @moduledoc """
  API client for National weather service
  """

  @doc """
  Fetch weather based on slug
  """
  def fetch(slug) do
    IO.puts("Fetching weather for #{slug}")
  end
end
