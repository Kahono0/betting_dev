defmodule Bet.Repo.Migrations.RemoveNameAndDescriptionMatch do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      remove :name
      remove :description
    end
  end
end
