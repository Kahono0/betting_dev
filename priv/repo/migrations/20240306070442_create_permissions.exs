defmodule Bet.Repo.Migrations.CreatePermissions do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :name, :string
      add :role_id, references(:roles, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end
  end
end
