defmodule BetWeb.LoginLive.Index do
  use BetWeb, :live_view

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
    |> assign(:page_title, "Login")
    |> assign(:error, nil)
    |> assign_form(%User{} |> User.changeset(%{}))
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    socket
    |> assign(:form, to_form(changeset))
  end
end
