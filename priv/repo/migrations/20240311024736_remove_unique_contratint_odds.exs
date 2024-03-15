defmodule Bet.Repo.Migrations.RemoveUniqueContratintOdds do
  use Ecto.Migration

  def change do
    # undo create unique_index(:odds, [:match_id, :odd])
    drop index(:odds, [:match_id, :odd])
  end
end
