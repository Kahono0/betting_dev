defmodule Bet.Repo.Migrations.AddDeletedAtUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :deleted_at, :utc_datetime
    end
  end
end
