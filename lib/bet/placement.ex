defmodule Bet.Placement do
  @moduledoc """
  The Placement context.
  """

  import Ecto.Query, warn: false
  alias Bet.Mailer
  alias Bet.Email
  alias Bet.Sports.Match
  alias Bet.Repo

  alias Bet.Placement.Odd
  alias Bet.Placement.Slip
  alias Bet.Placement.SlipOdd

  @doc """
  Returns the list of odds.

  ## Examples

      iex> list_odds()
      [%Odd{}, ...]

  """
  def list_odds do
    Repo.all(Odd)
  end

  @doc """
  Gets a single odd.

  Raises `Ecto.NoResultsError` if the Odd does not exist.

  ## Examples

      iex> get_odd!(123)
      %Odd{}

      iex> get_odd!(456)
      ** (Ecto.NoResultsError)

  """
  def get_odd!(id), do: Repo.get!(Odd, id)

  @doc """
  Creates a odd.

  ## Examples

      iex> create_odd(%{field: value})
      {:ok, %Odd{}}

      iex> create_odd(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_odd(attrs \\ %{}) do
    # %Odd{}
    # |> Odd.changeset(attrs)
    # |> Repo.insert()
    # check if attrs.match_id exists
    # if exist, check if odd exist, update, else insert
    case attrs["match_id"] do
      nil ->
        IO.puts("Doexn't exist on params")
        Odd.changeset(%Odd{}, attrs) |> Repo.insert()

      id ->
        odd = Repo.get_by(Odd, match_id: id, name: attrs["name"])

        case odd do
          nil ->
            Odd.changeset(%Odd{}, attrs) |> Repo.insert()

          odd ->
            Odd.changeset(odd, attrs) |> Repo.update()
        end
    end
  end

  @doc """
  Updates a odd.

  ## Examples

      iex> update_odd(odd, %{field: new_value})
      {:ok, %Odd{}}

      iex> update_odd(odd, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_odd(%Odd{} = odd, attrs) do
    odd
    |> Odd.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a odd.

  ## Examples

      iex> delete_odd(odd)
      {:ok, %Odd{}}

      iex> delete_odd(odd)
      {:error, %Ecto.Changeset{}}

  """
  def delete_odd(%Odd{} = odd) do
    Repo.delete(odd)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking odd changes.

  ## Examples

      iex> change_odd(odd)
      %Ecto.Changeset{data: %Odd{}}

  """
  def change_odd(%Odd{} = odd, attrs \\ %{}) do
    Odd.changeset(odd, attrs)
  end

  @doc """
  Create a slip
  """
  def create_slip(attrs \\ %{}) do
    new_slip =
      %Slip{}
      |> Slip.changeset(attrs)
      |> Repo.insert()

    slip =
      case(new_slip) do
        {:ok, slip} -> slip |> Repo.preload(:odds)
        {:error, changeset} -> changeset
      end

    slip
  end

  @doc """
  Updates a slip.
  """
  def update_slip(%Slip{} = slip, attrs) do
    slip
    |> Slip.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a slip.
  """

  def delete_slip(%Slip{} = slip) do
    Repo.delete(slip)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking slip changes.
  """
  def change_slip(%Slip{} = slip, attrs \\ %{}) do
    Slip.changeset(slip, attrs)
  end

  @doc """
  get a slip preloaded with odds
  """
  def get_slip_with_odds!(id) do
    Repo.get!(Slip, id) |> Repo.preload(odds: :match)
  end

  @doc """
  add an odd to a slip
  """
  def add_odd_to_slip(%Slip{} = slip, %Odd{} = odd) do
    # if match_id and odd are exist, then remove odd from slip
    if odd_in_slip(slip, odd) do
      remove_odd_from_slip(slip, odd)
      Repo.get!(Slip, slip.id) |> Repo.preload(:odds)
    else
      case match_in_slip(slip, odd.match_id) do
        nil ->
          insert_odd(slip, odd)
          IO.puts("Odd not in slip")

        existing_odd ->
          case remove_odd_from_slip(slip, existing_odd) do
            {:ok, _} -> IO.puts("Odd removed from slip")
          end

          insert_odd(slip, odd)
      end

      Repo.get!(Slip, slip.id) |> Repo.preload(:odds)
    end
  end

  def insert_odd(slip, odd) do
    changeset =
      SlipOdd.changeset(%SlipOdd{}, %{
        slip_id: slip.id,
        odd_id: odd.id
      })

    Repo.insert(changeset)
  end

  defp odd_in_slip(slip, odd) do
    odds = slip.odds
    Enum.any?(odds, fn x -> x.id == odd.id end)
  end

  defp match_in_slip(slip, match_id) do
    odds = slip.odds
    Enum.find(odds, fn x -> x.match_id == match_id end)
  end

  @doc """
  remove an odd from a slip
  """
  def remove_odd_from_slip(slip, odd) do
    from(s in SlipOdd, where: s.odd_id == ^odd.id and s.slip_id == ^slip.id)
    |> Repo.delete_all()

    {:ok, "Odd removed from slip"}
  end

  @doc """
  Checks if a user has a slip they have not placed yet
  """
  def get_open_slip(user) do
    Repo.get_by(Slip, user_id: user.id, status: "open") |> Repo.preload(:odds)
  end

  @doc """
  Returns a list of odd ids present in a slip
  """
  def get_odd_ids(slip) do
    odds = slip.odds
    Enum.map(odds, fn x -> x.id end)
  end

  def calculate_total_odds(slip) do
    odds = slip.odds
    total_odds = Enum.reduce(odds, 1.0, fn x, acc -> acc * x.odd end)
    Float.floor(total_odds, 2)
  end

  @doc """
  Get the end time of the latest match in a slip
  """
  def get_end_time(slip) do
    odds = slip.odds

    end_time = Enum.at(odds, 0).match.ends

    et_time =
      Enum.reduce(odds, end_time, fn x, acc ->
        if x.match.ends > acc do
          x.match.ends
        else
          acc
        end
      end)

    et_time
  end

  @doc """
  Get the start time of a slip
  """
  def get_start_time(slip) do
    odds = slip.odds

    start_time = Enum.at(odds, 0).match.starts

    st_time =
      Enum.reduce(odds, start_time, fn x, acc ->
        if x.match.starts < acc do
          x.match.starts
        else
          acc
        end
      end)

    st_time
  end

  @doc """
  Get all slips for a user
  """
  def list_slips(user) do
    slips =
      from(s in Slip, where: s.user_id == ^user.id)
      |> Repo.all()
      |> Repo.preload(odds: :match)

    # return slips where total odds is not 0
    Enum.filter(slips, fn x -> x.odds != [] end)
  end

  @doc """
  Get a single slip
  """
  def get_slip!(id) do
    Repo.get!(Slip, id)
  end

  @doc """
  Cancel a slip
  """
  def cancel_slip(slip) do
    slip
    |> Slip.changeset(%{status: "cancelled"})
    |> Repo.update()
  end

  @doc """
  Check if a slip can be cancelled and by a user
  """
  def can_cancel_slip?(slip, user) do
    case slip.status do
      "open" ->
        case user do
          nil -> false
          user -> user.id == slip.user_id
        end

      "placed" ->
        case slip.start do
          nil ->
            false

          start ->
            case DateTime.compare(start, DateTime.utc_now()) do
              :lt -> false
              _ -> true
            end
        end

      _ ->
        false
    end
  end

  @doc """
  Complete odd

  Given a completed odd, check if odd.match.ends is >= slip.end and mark slip as ("won", "lost")
  """
  def complete_odd(%Odd{} = odd) do
    match = odd.match
    slips = odd.slips

    # complete match
    match
    |> Match.changeset(%{status: "completed"})
    |> Repo.update()

    Enum.each(slips, fn slip ->
      if match.ends >= slip.end do
        complete_slip(slip)
      end
    end)
  end

  defp complete_slip(slip) do
    slip = Repo.get!(Slip, slip.id) |> Repo.preload([:odds, :user])
    odds = slip.odds
    # if status != placed, then return
    case slip.status do
      "placed" ->
        if Enum.reduce(odds, true, fn x, acc -> acc && x.status == "won" end) do
          slip
          |> Slip.changeset(%{status: "won"})
          |> Repo.update()

          email = Email.won_email(slip.user.email, to_str(slip))
          Mailer.deliver_now(email)

          IO.puts("Slip won")
        else
          slip
          |> Slip.changeset(%{status: "lost"})
          |> Repo.update()

          email = Email.lost_email(slip.user.email, to_str(slip))
          Mailer.deliver_now(email)
          IO.puts("Slip lost")
        end

      _ ->
        IO.puts("Slip not placed")
    end
  end

  defp to_str(slip) do
    slip_string = "Slip: #{slip.id}\n"
    slip_string = slip_string <> "Stake: #{slip.stake}\n"
    slip_string = slip_string <> "Total Odds: #{slip.total_odds}\n"
    slip_string = slip_string <> "Payout: #{slip.payout}\n"

    slip_string
  end

  @doc """
  Counts all bet slips.
  """
  def count_all_slips do
    from(s in Slip, where: s.status != "open", select: count(s.id))
    |> Repo.one()
  end

  @doc """
  Counts all bets lost.
  """
  def count_bets_lost do
    from(s in Slip, where: s.status == "lost", select: count(s.id))
    |> Repo.one()
  end

  @doc """
  Counts all bets won.
  """
  def count_bets_won do
    from(s in Slip, where: s.status == "won", select: count(s.id))
    |> Repo.one()
  end

  @doc """
  Calculates the total amount lost by users.
  """
  def total_amount_lost do
    from(s in Slip, where: s.status == "lost", select: sum(s.stake))
    |> Repo.one()
  end

  @doc """
  Calculates the total amount won by users.
  """
  def total_amount_won do
    from(s in Slip, where: s.status == "won", select: sum(s.payout))
    |> Repo.one()
  end
end
