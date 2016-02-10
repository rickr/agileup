defmodule Agileup.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :identity, :string

      timestamps
    end

  end
end
