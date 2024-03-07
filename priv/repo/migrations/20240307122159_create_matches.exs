defmodule Bet.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :name, :string
      add :description, :string

      timestamps(type: :utc_datetime)
    end
  end
end
