defmodule Bet.Repo do
  use Ecto.Repo,
    otp_app: :bet,
    adapter: Ecto.Adapters.Postgres
end
