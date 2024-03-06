defmodule Bet.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :name, :string
    has_many :permissions, Bet.Accounts.Permission
    has_many :users, Bet.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 3)
    |> unique_constraint(:name)
  end

end
