defmodule BetWeb.UsersLive.Index do
  use BetWeb, :live_view

  alias Bet.Sports
  alias Bet.Placement
  alias Bet.Accounts

  @impl true
  def mount(_params, session, socket) do
    sport = Sports.get_sport!(1)
    matches = Sports.list_pending_matches(sport)

    IO.inspect(matches)

    user = get_current_user(session["session"])

    slip = initialize_slip(user)

    socket =
      socket
      |> assign(:matches, matches)
      |> assign(:slip, slip)
      |> assign(:current_user, user)
      |> assign(:odd_ids, Placement.get_odd_ids(slip))
      |> assign(:changeset, Placement.change_slip(slip))
      |> assign(:total_odds, Placement.calculate_total_odds(slip))

    {:ok, socket}
  end

  @impl true
  def handle_event("choose_odd", %{"id" => id}, socket) do
    # if the odd is already chosen, remove it
    id = String.to_integer(id)

    odd = Placement.get_odd!(id)

    slip = Placement.get_slip_with_odds!(socket.assigns.slip.id)

    slip = add_odd_to_slip(slip, odd)

    slip = Placement.get_slip_with_odds!(slip.id)

    socket =
      socket
      |> assign(:odd_ids, Placement.get_odd_ids(slip))
      |> assign(:slip, slip)
      |> assign(:total_odds, Placement.calculate_total_odds(slip))

    # |> assign(socket, slip: slip)

    {:noreply, socket}
  end

  def handle_event("update_stake", %{"slip" => slip}, socket) do
    IO.puts("Changed!!!")

    stake =
      try do
        String.to_integer(slip["stake"])
      rescue
        _ -> 0
      end

    if stake == 0 do
      {:reply, %{:error => "Stake must be a number"}, socket}
    end

    socket.assigns.slip
    |> Placement.update_slip(%{
      stake: stake,
      payout: Float.floor(stake * socket.assigns.slip.total_odds, 2)
    })

    socket =
      socket
      |> assign(:slip, Placement.get_slip_with_odds!(socket.assigns.slip.id))

    {:reply, %{:ok => "Stake updated"}, socket}
  end

  def handle_event("place_bet", _unsigned_params, socket) do
    IO.puts("Placing bet")
    IO.inspect(socket.assigns.slip, label: "Slip")
    IO.puts(socket.assigns.total_odds)
    IO.puts(socket.assigns.slip.stake)

    slip = socket.assigns.slip
    total_odds = socket.assigns.total_odds

    slip
    |> Placement.update_slip(%{
      status: "placed",
      start: Placement.get_start_time(slip),
      end: Placement.get_end_time(slip),
      total_odds: total_odds,
      payout: Float.floor(slip.stake * total_odds, 2)
    })

    new_slip = initialize_slip(socket.assigns.current_user)

    {:noreply,
     socket
     |> put_flash(:info, "Bet placed successfully")
     |> assign(:slip, new_slip)
     |> assign(:odd_ids, [])}
  end

  defp initialize_slip(user) do
    case Placement.get_open_slip(user) do
      nil ->
        create_slip(user)

      slip ->
        slip
    end
  end

  defp create_slip(user) do
    Placement.create_slip(%{
      status: "open",
      stake: 0.0,
      payout: 0.0,
      total_odds: 0.0,
      start: DateTime.utc_now(),
      end: DateTime.utc_now(),
      user_id: user.id
    })
  end

  defp add_odd_to_slip(slip, odd) do
    Placement.add_odd_to_slip(slip, odd)
  end

  defp get_current_user(token) do
    Accounts.get_user_by_token(token)
  end

  # defp get_odd(odds, name) do
  #   Enum.find(odds, fn x -> x.name == name end)
  # end
end
