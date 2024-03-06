defmodule Bet.Accounts.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "permissions" do
    field :name, :string
    belongs_to :role, Bet.Accounts.Role

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 3)
    |> unique_constraint(:name)
  end

  @doc false
  def assign_role_changeset(permission, role) do
    permission
    |> cast(%{role_id: role.id}, [:role_id])
    |> validate_required([:role_id])
  end
end
