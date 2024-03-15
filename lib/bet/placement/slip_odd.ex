defmodule Bet.Placement.SlipOdd do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bet.Placement.Slip
  alias Bet.Placement.Odd

  schema "slip_odds" do
    belongs_to :slip, Slip
    belongs_to :odd, Odd
  end

  @doc false
  def changeset(slip_odd, attrs) do
    slip_odd
    |> cast(attrs, [:slip_id, :odd_id])
    |> validate_required([:slip_id, :odd_id])
  end
end
