defmodule Bet.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BetWeb.Telemetry,
      Bet.Repo,
      {DNSCluster, query: Application.get_env(:bet, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Bet.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Bet.Finch},
      # Start a worker by calling: Bet.Worker.start_link(arg)
      # {Bet.Worker, arg},
      # Start to serve requests, typically the last entry
      BetWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bet.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BetWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
