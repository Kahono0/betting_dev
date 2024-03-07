defmodule BetWeb.UsersLive.Index do
  use BetWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Users</h1>
    <p>Users will be listed here</p>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
