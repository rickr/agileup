defmodule Agileup.Repo.Migrations.RenameUsersIdentityToIdentifier do
  use Ecto.Migration

  def change do
    rename table(:users), :identity, to: :identifier
  end
end
