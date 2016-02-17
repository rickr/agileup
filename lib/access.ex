defmodule Agileup.Access do
  require Logger
  use Agileup.Web, :controller

  def unauthenticated(conn, _params) do
    redirect conn, to: "/login"
  end
end
