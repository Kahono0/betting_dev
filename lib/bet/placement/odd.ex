defmodule Bet.Placement.Odd do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bet.Sports.Match
  alias Bet.Placement.Slip
  alias Bet.Placement.SlipOdd

  schema "odds" do
    field :name, :string
    field :status, :string
    field :odd, :float

    belongs_to :match, Match
    many_to_many :slips, Slip, join_through: SlipOdd

    timestamps(type: :utc_datetime)

  end

  @doc false
  def changeset(odd, attrs) do
    odd
    |> cast(attrs, [:odd, :name, :status, :match_id])
    |> validate_required([:odd, :name, :status, :match_id])
  end
end
