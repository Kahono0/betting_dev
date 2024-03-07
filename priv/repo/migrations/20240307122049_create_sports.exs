defmodule Bet.Repo.Migrations.CreateSports do
  use Ecto.Migration

  def change do
    create table(:sports) do
      add :name, :string
      add :description, :string

      timestamps(type: :utc_datetime)
    end
  end
end
