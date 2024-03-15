defmodule BetWeb.UsersLoginController do
  use BetWeb, :controller

  def login(conn, %{"user" => user_params}) do
    case Bet.Accounts.authenticate_user(user_params) do
      {:ok, session} ->
        # conn
        # |> put_session(:session, session)
        # |> put_flash(:info, "Welcome back!")
        # |> redirect(to: "/")
        case Bet.Accounts.get_user_by_token(session) do
          nil ->
            conn
            |> put_flash(:error, "Invalid email or password")
            |> redirect(to: "/login")

          user ->
            conn
            |> put_session(:session, session)
            |> put_flash(:info, "Welcome back!")
            |> redirect_to_relevant(user)
        end

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> redirect(to: "/login")
    end
  end

  defp redirect_to_relevant(conn, user) do
    case user.role.name do
      "admin" ->
        conn
        |> redirect(to: "/admin")

        "superuser" ->
        conn
        |> redirect(to: "/admin")

      "frontend-access" ->
        conn
        |> redirect(to: "/users")
    end
  end
end
