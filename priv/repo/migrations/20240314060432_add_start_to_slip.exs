defmodule Bet.Repo.Migrations.AddStartToSlip do
  use Ecto.Migration

  def change do
    alter table(:slips) do
      add :start, :naive_datetime
    end
  end
end
