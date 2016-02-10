defmodule Agileup.SessionController do
  require Logger

  use Agileup.Web, :controller

  alias Agileup.User

  def new(conn, _params), do: render conn, "login.html"

  def create(conn, %{"token" => token}) do
    case get_auth_info_for(token) do
      {:ok, body} ->
        identifier = body
        |> parse_response
        |> extract_identifier
      {:failed} ->
        conn
        |> put_flash(:error, "Uh oh. We failed to log you in...")
        |> assign(:has_error, true)
        |> render("login.html")
    end

    Logger.debug("Identifier: #{identifier}")
    conn
    |> create_session(identifier)
    |> Guardian.Plug.sign_in(identifier)
    |> redirect to: "/"
  end

  def get_auth_info_for(token) do
    Logger.info "Getting auth info for #{token}"
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

  defp api_url do
    Application.get_env(:agileup, :janrain_api_url)
  end

  defp api_key do
    Application.get_env(:agileup, :janrain_api_key)
  end

  defp generate_payload_for(token) do
    [apiKey: api_key, token: token]
  end

  defp parse_response(body) do
    Logger.info "Parsing body #{body}"
    Poison.decode! body
  end

  defp extract_identifier(parsed_body) do
    %{"profile" => %{"identifier" => identifier}, "stat" => status} = parsed_body
    Logger.info "Got status: #{status} for #{identifier}"
    identifier
  end

  defp create_session(conn, identifier) do
    Logger.debug "Checking for user with identifier #{identifier}"
    Logger.debug "User.new? #{identifier}: #{User.new?(identifier)}"
    if User.new?(identifier), do:  save_identifier identifier
    conn
  end

  defp save_identifier(identifier) do
    Logger.debug "Saving user with identifier #{identifier}"
    changeset = User.changeset(%User{}, %{identifier: identifier})
    case Repo.insert(changeset) do
      {:ok, _user} ->
        Logger.debug "Inserted"
      {:error, _changeset} ->
        Logger.error "Unable to create user for identifier #{identifier}"
    end
  end
end
