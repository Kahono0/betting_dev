defmodule Bet.Worker do
  alias Bet.Sports

  use Oban.Worker, queue: :events

  @impl Oban.Worker
  def perform(args) do
    match_id = args.args["match_id"]
    IO.puts("Worker is working")
    # get match from args
    match = Sports.get_match!(match_id)

    Sports.complete_match(match)
    :ok
  end
end
