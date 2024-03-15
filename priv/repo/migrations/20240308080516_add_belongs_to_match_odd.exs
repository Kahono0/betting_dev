defmodule Bet.Repo.Migrations.AddBelongsToMatchOdd do
  use Ecto.Migration

  def change do
    alter table(:odds) do
      add :match_id, references(:matches, on_delete: :delete_all)
    end
  end
end
