defmodule Agileup.User do
  use Agileup.Web, :model
  import Ecto.Query

  schema "users" do
    field :name, :string
    field :identifier, :string
    field :slack_webhook, :string

    timestamps
  end

  @required_fields ~w(identifier)
  @optional_fields ~w(name slack_webhook)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:name, min: 2)
    |> validate_format(:slack_webhook, ~r/https:\/\/hooks\.slack\.com\/services/)
  end

  def new?(identifier) do
    query = from u in Agileup.User, where: u.identifier == ^identifier
    Agileup.Repo.all(query)
    |> length == 0
  end
end
