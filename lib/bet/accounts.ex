defmodule Bet.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Bet.Repo

  alias Bet.Accounts.User
  alias Bet.Accounts.Role
  alias Bet.Accounts.Permission

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id) |> Repo.preload(role: :permissions)

  @doc """
  Gets a single user by token.
  """
  def get_user_by_token(token) do
    case token do
      nil -> nil
      _ -> Repo.get_by(User, session: token) |> Repo.preload(role: :permissions)
    end
  end

  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)
  """
  def get_role!(id), do: Repo.get!(Role, id) |> Repo.preload(:permissions)

  def get_role_by_name(name) do
    Repo.get_by(Role, name: name)
  end

  @doc """
  Check if a user has a role.

  ## Examples

      iex> has_role(user, role)
      true

      iex> has_role(user, bad_role)
      false
  """
  def has_role(user, role) do
    user.role_id == role.id
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a role.

  ## Examples

      iex> create_role(%{name: "admin"})
      {:ok, %Role{}}

      iex> create_role(%{})
      {:error, %Ecto.Changeset{}}
  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Authenticates a user.

  ## Examples

      iex> authenticate_user(%{email: "user@example.com", password: "password"})
      {:ok, %User{}}


  """
  def authenticate_user(user_params) do
    email = user_params["email"]
    password = user_params["password"]
    IO.puts("email: #{email} and password: #{password}")
    user = Repo.get_by(User, email: email)

    case user do
      nil ->
        {:error, User.changeset(%User{}, %{})}

      _ ->
        case is_valid_password?(password, user) do
          true -> {:ok, create_new_token(user)}
          false -> {:error, %{}}
        end
    end
  end

  defp create_new_token(user) do
    token = :crypto.strong_rand_bytes(128) |> Base.encode64()

    user
      |> User.changeset(%{session: token})
      |> Repo.update()

    token
  end

  defp is_valid_password?(password, user) do
    Bcrypt.verify_pass(password, user.password)
  end

  @doc """
  Assigns a role to a user.

  ## Examples

      iex> assign_role(user, role)
      {:ok, %User{}}

      iex> assign_role(user, bad_role)
      {:error, %Ecto.Changeset{}}
  """
  def assign_role(%User{} = user, %Role{} = role) do
    user
    |> User.assign_role_changeset(role)
    |> Repo.update()
  end

  @doc """
  Creates a permission.

  ## Examples

      iex> create_permission(%{name: "create_user"})
      {:ok, %Permission{}}

      iex> create_permission(%{})
      {:error, %Ecto.Changeset{}}
  """
  def create_permission(attrs \\ %{}) do
    %Permission{}
    |> Permission.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Assigns a permission to a role.

  ## Examples

      iex> assign_permission(role, permission)
      {:ok, %Role{}}

      iex> assign_permission(role, bad_permission)
      {:error, %Ecto.Changeset{}}
  """
  def assign_permission(%Role{} = role, %Permission{} = permission) do
    permission
    |> Permission.assign_role_changeset(role)
    |> Repo.update()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
