defmodule BetWeb.Auth do
  use BetWeb, :controller
  alias Bet.Accounts

  import Plug.Conn

  def init(opts), do: opts

  defp get_user(conn) do
    token = get_session(conn, :session)
    case Accounts.get_user_by_token(token) do
      nil -> nil
      user -> user
    end
  end

  defp redirect_if_unauthorized(conn) do
    if get_user(conn) do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access this page")
      |> redirect(to: "/login")
      |> halt()
    end
  end

  def call(conn, _opts) do
    IO.puts("=====================================================================")
    case get_user(conn) do
      nil ->
        redirect_if_unauthorized(conn)

      user ->
        conn
          |> assign(:current_user, user)
    end
  end
end
