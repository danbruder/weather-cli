defmodule Weather.NWS do
  @user_agent [{"User-agent", "Dan Bruder"}]
  @nws_url Application.get_env(:weather, :nws_url)

  @moduledoc """
  API client for National weather service
  """

  @doc """
  Fetch weather based on slug
  """
  def fetch(slug) do
    slug
    |> weather_url
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def weather_url(slug), do: "#{@nws_url}/xml/current_obs/#{slug}.xml"

  def handle_response({:ok, %{status_code: status_code, body: body}}) do
    {status_code |> check_for_error, body}
  end

  def handle_response({_, %{status_code: _, body: body}}) do
    {:error, body}
  end

  def check_for_error(200), do: :ok
  def check_for_error(_), do: :error
end
