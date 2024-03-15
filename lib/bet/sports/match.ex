defmodule Bet.Sports.Match do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bet.Sports.Sport
  alias Bet.Placement.Odd

  schema "matches" do
    field :home, :string
    field :away, :string
    field :date, :utc_datetime
    field :starts, :utc_datetime
    field :ends, :utc_datetime
    field :status, :string

    belongs_to :sport, Sport
    has_many :odds, Odd


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [:home, :away, :date, :starts, :ends, :status, :sport_id])
    |> validate_required([:home, :away, :date, :starts, :ends, :status])
  end
end
