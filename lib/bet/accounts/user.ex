defmodule Bet.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bet.Repo

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :msisdn, :string
    field :password, :string
    belongs_to :role, Bet.Accounts.Role

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :msisdn, :password])
    |> validate_required([:first_name, :last_name, :email, :msisdn, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> is_unique_email
    |> hash_password
  end

  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :password, Bcrypt.hash_pwd_salt(password))
    end
  end

  defp is_unique_email(changeset) do
    case get_change(changeset, :email) do
      nil ->
        changeset

      email ->
        case Repo.get_by(Bet.Accounts.User, email: email) do
          nil -> changeset
          _ -> add_error(changeset, :email, "has already been taken")
        end
    end
  end

  @doc false
  def assign_role_changeset(user, role) do
    user
    |> cast(%{role_id: role.id}, [:role_id])
    |> validate_required([:role_id])
  end
end
