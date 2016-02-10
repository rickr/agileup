defmodule AgileUp.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Agileup.Repo
  alias Agileup.User

  def for_token(identifier), do: { :ok, "identifier:#{identifier}" }

  def from_token("identifier:" <> identifier), do: { :ok, Repo.get_by(User, identifier: identifier) }
end
