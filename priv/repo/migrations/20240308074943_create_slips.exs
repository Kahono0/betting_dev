defmodule Bet.Repo.Migrations.CreateSlips do
  use Ecto.Migration

  def change do
    create table(:slips) do
      add :stake, :float
      add :payout, :float
      add :odds, :float
      add :end, :naive_datetime
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
