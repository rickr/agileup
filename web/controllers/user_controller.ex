defmodule Agileup.UserController do
  require Logger
  use Agileup.Web, :controller
  use Guardian.Phoenix.Controller

  alias Agileup.User

  plug Guardian.Plug.EnsureAuthenticated, handler: Agileup.Access

  # GET /settings
  def edit(conn, _params, user, _claims) do
    conn
    |> assign(:user, user)
    |> render "edit.html"
  end

  # POST /settings
  def update(conn, %{"settings" => settings}, user, _claims) do
    Logger.debug "Updating user id #{user.id} with #{inspect settings}"

    changeset = User.changeset(user, settings)
    Logger.debug(inspect changeset)
    if changeset.valid? do
      Repo.update(changeset)

      conn
      |> put_flash(:success, "Your settings have been saved")
      |> redirect to: page_path(conn, :index)
    else
      conn
      |> put_flash(:error, "There was a problem saving your settings.")
      |> render("edit.html", user: user, changeset: changeset)
    end
  end
end
