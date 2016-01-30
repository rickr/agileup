defmodule Agileup.PageController do
  use Agileup.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
