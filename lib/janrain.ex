defmodule Janrain do
  require Logger

  @moduledoc """
  Provides some convenient functions for working with Janrain social login, Guardian, and Phoenix.

  In your Janrain callback function grab the token that's passed to you and then:

  user_logged_in = Janrain.authenticate_user_with token
  case user_logged_in do
    {:ok, profile_info}
      conn
      |> Guardian.Plug.sign_in(identifier)
      |> redirect to: "/"
    {:failed}
      conn
      |> put_flash(:error, "Uh oh. We failed to log you in...")
      |> render("login.html")
  end
  """

  @doc """
  Authenticates a user via a `token` provided by Janrains callback and attempts to get their profile info

  Returns `{:ok, profile_info}`.

  Returns `{:failed}`.

  ## Examples
  iex> Janrain.authenticate_user_with("not_a_good_token")
  {:failed}
  """
  def authenticate_user_with(token) do
    token
    |> get_auth_info
    |> parse_auth_info
  end

  defp get_auth_info(token) do
    case HTTPoison.post(api_url, {:form, generate_payload_for(token)}) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{body: body}} ->
        Logger.error "Failed to get auth_info: #{body}"
        {:failed}
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error "Failed to get auth_info: #{reason}"
        {:failed}
    end
  end

  defp parse_auth_info(body) do
    case body do
      {:ok, body} ->
        Logger.info "Parsing body #{body}"
        Poison.decode! body
      {:failed} -> {:failed}
    end
  end


  defp api_url do
    System.get_env("JANRAIN_API_URL")
  end

  defp api_key do
    Application.get_env(:agileup, :janrain_api_key)
  end

  defp generate_payload_for(token) do
    [apiKey: api_key, token: token]
  end
end
