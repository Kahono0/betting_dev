defmodule Bet.Repo.Migrations.AddSessionToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :session, :string
    end
  end
end
