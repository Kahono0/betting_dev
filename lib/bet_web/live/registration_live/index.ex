defmodule BetWeb.RegistrationLive.Index do
  use BetWeb, :live_view

  alias Bet.Accounts
  alias Bet.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Registration")
    |> assign_form(%User{} |> User.changeset(%{}))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Register")
    |> assign(:user, %User{})
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    socket
    |> assign(:form, to_form(changeset))
  end

  @impl true
  def handle_event("submit", %{"user" => user_params}, socket) do
    role = Accounts.get_role_by_name("frontend-access")

    case Accounts.create_user(user_params) do
      {:ok, user} ->
        case Accounts.assign_role(user, role) do
          {:ok, token} -> {:noreply, add_session(socket, token)}
          {:error, _} -> {:noreply, assign_form(socket, User.changeset(user, user_params))}
        end

      {:error, changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp add_session(socket, token) do
    socket
    |> put_flash(:info, "Welcome!")
    |> push_redirect(to: "/")
    |> assign(:user_token, token)
  end
end
