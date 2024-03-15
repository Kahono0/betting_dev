defmodule Bet.Repo.Migrations.AddRelationShipsToSlip do
  use Ecto.Migration

  def change do
    alter table(:slips) do
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
