ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Agileup.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Agileup.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Agileup.Repo)
