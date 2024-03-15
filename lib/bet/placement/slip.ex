defmodule Bet.Placement.Slip do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bet.Accounts.User
  alias Bet.Placement.Odd
  alias Bet.Placement.SlipOdd

  schema "slips" do
    field :status, :string
    field :start, :utc_datetime
    field :end, :utc_datetime
    field :stake, :float
    field :payout, :float
    field :total_odds, :float

    belongs_to :user, User
    many_to_many :odds, Odd, join_through: SlipOdd

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(slip, attrs) do
    slip
    |> cast(attrs, [:stake, :payout, :total_odds, :start, :end, :status, :user_id])
    |> validate_required([:stake, :payout, :total_odds, :start, :end, :status, :user_id])
  end
end
