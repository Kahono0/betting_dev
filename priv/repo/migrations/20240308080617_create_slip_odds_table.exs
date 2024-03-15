defmodule Bet.Repo.Migrations.CreateSlipOddsTable do
  use Ecto.Migration

  def change do
    create table(:slip_odds) do
      add :slip_id, references(:slips, on_delete: :delete_all)
      add :odd_id, references(:odds, on_delete: :delete_all)
    end
  end
end
