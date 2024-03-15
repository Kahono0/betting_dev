defmodule Bet.Repo.Migrations.ChangeColumnOddsToTotalOdds do
  use Ecto.Migration

  def change do
    alter table(:slips) do
      remove :odds
      add :total_odds, :float
    end
  end
end
