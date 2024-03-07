defmodule Bet.Repo.Migrations.HasManyMatchesSports do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      add :sport_id, references(:sports, on_delete: :delete_all)
    end
  end
end
