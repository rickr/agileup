defmodule Agileup.Repo.Migrations.AddSlackWebhookToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :slack_webhook, :text
    end
  end
end
