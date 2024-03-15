defmodule BetWeb.AdminLive.ViewBets do
  alias Bet.Placement
  alias Bet.Accounts
  use Phoenix.LiveView, layout: {BetWeb.Layouts, :admin}
  import BetWeb.CoreComponents

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container px-4 mx-auto">
      <%= if @user do %>
        <h1 class="text-2xl text-center">View Bet slips for <%= @user.first_name %></h1>
        <%= if Enum.count(@slips) > 0 do %>
          <.bet_slip slips={@slips} can_edit={false} />
        <% else %>
          <p class="mt-6 text-center text-xl">No bet slips found for this user</p>
        <% end %>
      <% else %>
        <h1 class="text-2xl text-center">User was not found!</h1>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    case Accounts.get_user(id) do
      nil ->
        {:ok, assign(socket, user: nil)}

      user ->
        slips = Placement.list_slips(user)
        {:ok, assign(socket, user: user, slips: slips)}
    end
  end
end
