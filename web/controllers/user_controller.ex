defmodule Agileup.UserController do
  require Logger
  use Agileup.Web, :controller
  use Guardian.Phoenix.Controller

  plug Guardian.Plug.EnsureAuthenticated, handler: Agileup.Access


  # GET /settings
  def edit(conn, _params, user, _claims) do
    render conn, "edit.html"
  end

  # POST /settings
  def update(conn, _params, user, _claims) do
    render conn, "edit.html"
  end
end
