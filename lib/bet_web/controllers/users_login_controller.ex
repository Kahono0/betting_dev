defmodule BetWeb.UsersLoginController do
  use BetWeb, :controller

  def login(conn, %{"user" => user_params}) do
    case Bet.Accounts.authenticate_user(user_params) do
      {:ok, session} ->
        conn
        |> put_session(:session, session)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: "/")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> redirect(to: "/login")
    end
  end
end
