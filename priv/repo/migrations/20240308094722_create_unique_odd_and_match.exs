defmodule Bet.Repo.Migrations.CreateUniqueOddAndMatch do
  use Ecto.Migration

  def change do
    create unique_index(:odds, [:match_id, :odd])
  end
end
