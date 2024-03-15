defmodule Bet.Repo.Migrations.AddFieldsToMatch do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      add :home, :string
      add :away, :string
      add :date, :utc_datetime
      add :starts, :utc_datetime
      add :ends, :utc_datetime
      add :status, :string
    end
  end
end
