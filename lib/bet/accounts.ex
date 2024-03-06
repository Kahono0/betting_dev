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
