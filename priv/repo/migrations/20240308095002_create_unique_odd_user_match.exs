defmodule Bet.Repo.Migrations.CreateUniqueOddUserMatch do
  use Ecto.Migration

  def change do
    create unique_index(:slip_odds, [:slip_id, :odd_id])
  end
end
