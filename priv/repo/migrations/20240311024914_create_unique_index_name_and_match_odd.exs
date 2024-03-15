defmodule Bet.Repo.Migrations.CreateUniqueIndexNameAndMatchOdd do
  use Ecto.Migration

  def change do
    create unique_index(:odds, [:name, :match_id])
  end
end
