defmodule Bet.Sports.Sport do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bet.Sports.Match

  schema "sports" do
    field :name, :string
    field :description, :string
    has_many :matches, Match


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(sport, attrs) do
    sport
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
