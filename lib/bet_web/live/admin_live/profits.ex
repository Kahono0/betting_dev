defmodule BetWeb.AdminLive.Profits do
  alias Bet.Placement
  alias Bet.Accounts
  use Phoenix.LiveView, layout: {BetWeb.Layouts, :admin}

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container px-4 mx-auto">
      <h1 class="text-xl my-4">Bets placed</h1>
      <div class="flex flex-wrap justify-around border rounded-lg p-8 gap-6">
        <%!-- cards for counts --%>
        <div class="w-1/4 p-4 border rounded flex flex-col justify-center items-center h-72">
          <h2 class="text-2xl">All Betslips Placed</h2>
          <p class="text-3xl"><%= @all_bets_count %></p>
        </div>

        <div class="w-1/4 p-4 border rounded flex flex-col justify-center items-center h-72">
          <h2 class="text-2xl">Betslips won</h2>
          <p class="text-3xl"><%= @won_bets_count %></p>
        </div>

        <div class="w-1/4 p-4 border rounded flex flex-col justify-center items-center h-72">
          <h2 class="text-2xl">Betslips lost</h2>
          <p class="text-3xl"><%= @lost_bets_count %></p>
        </div>
      </div>
      <h1 class="text-xl my-4">Profits and losses</h1>
      <div class="flex flex-wrap justify-around border rounded-lg p-8 gap-6">
        <%!-- cards for amounts --%>
        <div class="w-1/4 p-4 border rounded flex flex-col justify-center items-center h-72">
          <h2 class="text-2xl">Total amount won</h2>
          <p class="text-3xl"><%= @total_won_amount %></p>
        </div>

        <div class="w-1/4 p-4 border rounded flex flex-col justify-center items-center h-72">
          <h2 class="text-2xl">Total amount lost</h2>
          <p class="text-3xl"><%= @total_lost_amount %></p>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, session, socket) do
    _ = Accounts.get_user_by_token(session["session"])

    all_bets_count = Placement.count_all_slips()
    won_bets_count = Placement.count_bets_won()
    lost_bets_count = Placement.count_bets_lost()

    total_won_amount = Placement.total_amount_won()
    total_lost_amount = Placement.total_amount_lost()

    {:ok,
     assign(socket,
       all_bets_count: all_bets_count,
       won_bets_count: won_bets_count,
       lost_bets_count: lost_bets_count,
       total_won_amount: total_won_amount,
       total_lost_amount: total_lost_amount
     )}
  end
end
