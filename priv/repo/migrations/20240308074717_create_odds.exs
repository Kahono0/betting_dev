defmodule Bet.Repo.Migrations.CreateOdds do
  use Ecto.Migration

  def change do
    create table(:odds) do
      add :odd, :float
      add :name, :string
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
