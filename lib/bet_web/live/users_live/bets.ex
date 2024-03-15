defmodule BetWeb.UsersLive.Bets do
  alias Bet.Placement
  alias Bet.Accounts

  use BetWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto w-1/2">
      <h1>Your Bet slips</h1>
      <.bet_slip
        slips={@slips}
        can_edit={@can_edit}
        changeset={@changeset}
        current_user={@current_user}
      />
    </div>
    """
  end

  def mount(_params, session, socket) do
    user = Accounts.get_user_by_token(session["session"])
    slips = Placement.list_slips(user)
    changeset = Placement.Odd.changeset(%Placement.Odd{}, %{})
    {:ok, assign(socket, slips: slips, changeset: changeset, can_edit: true, current_user: user)}
  end

  def handle_event("cancel_bet", %{"id" => id}, socket) do
    id = String.to_integer(id)
    slip = Placement.get_slip!(id)
    {:ok, _} = Placement.cancel_slip(slip)
    slips = Placement.list_slips(socket.assigns.current_user)

    {:noreply,
     socket
     |> put_flash(:info, "Bet slip cancelled")
     |> assign(slips: slips)}
  end
end
