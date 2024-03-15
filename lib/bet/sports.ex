defmodule Bet.Sports do
  @moduledoc """
  The Sports context.
  """

  import Ecto.Query, warn: false
  alias Bet.Worker
  alias Bet.Repo

  alias Bet.Sports.Sport
  alias Bet.Sports.Match
  alias Bet.Placement.Odd
  alias Bet.Placement

  @doc """
  Returns the list of sports.

  ## Examples

      iex> list_sports()
      [%Sport{}, ...]

  """
  def list_sports do
    Repo.all(Sport)
  end

  @doc """
  Gets a single sport.

  Raises `Ecto.NoResultsError` if the Sport does not exist.

  ## Examples

      iex> get_sport!(123)
      %Sport{}

      iex> get_sport!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sport!(id), do: Repo.get!(Sport, id)

  @doc """
  Creates a sport.

  ## Examples

      iex> create_sport(%{field: value})
      {:ok, %Sport{}}

      iex> create_sport(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sport(attrs \\ %{}) do
    %Sport{}
    |> Sport.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sport.

  ## Examples

      iex> update_sport(sport, %{field: new_value})
      {:ok, %Sport{}}

      iex> update_sport(sport, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sport(%Sport{} = sport, attrs) do
    sport
    |> Sport.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sport.

  ## Examples

      iex> delete_sport(sport)
      {:ok, %Sport{}}

      iex> delete_sport(sport)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sport(%Sport{} = sport) do
    Repo.delete(sport)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sport changes.

  ## Examples

      iex> change_sport(sport)
      %Ecto.Changeset{data: %Sport{}}

  """
  def change_sport(%Sport{} = sport, attrs \\ %{}) do
    Sport.changeset(sport, attrs)
  end

  @doc """
  Create a match
  """
  def create_match(attrs \\ %{}) do
    match =
      %Match{}
      |> Match.changeset(attrs)
      |> Repo.insert()

    case match do
      {:ok, match} ->
        schedule_match(match)
        match |> Repo.preload([:sport, :odds])

      {:error, changeset} ->
        changeset
    end
  end

  def schedule_match(%Match{} = match) do
    # schedule_time is match.ends + 3 hours
    schedule_time = match.ends

    %{"match_id" => match.id}
    |> Worker.new(scheduled_at: schedule_time)
    |> Oban.insert()
  end

  @doc """
  Update a match
  """
  def update_match(%Match{} = match, attrs) do
    match
    |> Match.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Delete a match
  """
  def delete_match(%Match{} = match) do
    Repo.delete(match)
  end

  @doc """
  Adds a match to a sport
  """
  def add_match(%Sport{} = sport, %Match{} = match) do
    # add sport_id to match
    match
    |> Match.changeset(%{sport_id: sport.id})
    |> Repo.update()
  end

  @doc """
  Removes a match from a sport
  """
  def remove_match(%Sport{} = _sport, %Match{} = match) do
    # remove sport_id from match
    match
    |> Match.changeset(%{sport_id: nil})
    |> Repo.update()
  end

  @doc """
  Returns the list of matches for a sport
  """
  def list_matches(%Sport{} = sport) do
    sport
    |> Ecto.assoc(:matches)
    |> Repo.all()
    |> Repo.preload(:odds)
  end

  @doc """
  Returns a list of matches that have not yet started
  """
  def list_pending_matches(%Sport{} = sport) do
    time_now = DateTime.utc_now()

    from(m in Match,
      where: m.sport_id == ^sport.id and m.ends > ^time_now,
      preload: [:sport, :odds]
    )
    |> Repo.all()
  end

  @doc """
  Returns the list of matches.
  """
  def list_matches do
    Repo.all(Match) |> Repo.preload([:sport, :odds])
  end

  @doc """
  Gets a single match.
  """
  def get_match!(id), do: Repo.get!(Match, id) |> Repo.preload([:sport, odds: [:slips, :match]])

  @doc """
  Complete match

  Given a match, mark one of its odds as won and the rest as lost
  """
  def complete_match(%Match{} = match) do
    odds = match.odds
    odd_ids = Enum.map(odds, & &1.id)
    random = Enum.random(odd_ids)

    odds
    |> Enum.map(fn odd ->
      if odd.status == "active" do
        if odd.id == random do
          odd
          |> Odd.changeset(%{status: "won"})
          |> Repo.update()
        else
          odd
          |> Odd.changeset(%{status: "lost"})
          |> Repo.update()
        end
      end

      Placement.complete_odd(odd)
    end)
  end
end
