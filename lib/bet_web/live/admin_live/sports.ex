defmodule BetWeb.AdminLive.Sports do
  alias Bet.Placement
  alias Bet.Sports
  alias Bet.Accounts
  use Phoenix.LiveView, layout: {BetWeb.Layouts, :admin}
  import BetWeb.CoreComponents

  @impl true
  def render(assigns) do
    ~H"""
    <section class="container px-4 mx-auto">
      <div class="flex justify-between">
        <div class="flex items-center gap-x-3">
          <h2 class="text-lg font-medium text-gray-800 dark:text-white">
            Sports
          </h2>
          <span class="px-3 py-1 text-xs text-blue-600 bg-blue-100 rounded-full dark:bg-gray-800 dark:text-blue-400">
            <%= Enum.count(@sports) %> sports
          </span>
        </div>
        <.modal id="new_sport">
          <h1>New Sport</h1>
          <p class="my-4">Currently disabled!</p>
        </.modal>
        <button
          class="text-white px-4 py-2 bg-blue-500 rounded-lg float-right flex"
          phx-click={show_modal("new_sport")}
          phx-target="new_sport"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            class="w-6 h-6"
          >
            <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
          </svg>
          New Sport
        </button>
      </div>
      <div class="flex flex-col mt-6">
        <div class="-mx-4 -my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
          <div class="inline-block min-w-full py-2 align-middle md:px-6 lg:px-8">
            <div class="overflow-hidden border border-gray-200 dark:border-gray-700 md:rounded-lg">
              <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
                <thead class="bg-gray-50 dark:bg-gray-800">
                  <tr>
                    <th
                      scope="col"
                      class="py-3.5 px-4 text-sm font-normal text-left rtl:text-right text-gray-500 dark:text-gray-400"
                    >
                      <div class="flex items-center gap-x-3">
                        <span>Name</span>
                      </div>
                    </th>

                    <th
                      scope="col"
                      class="px-12 py-3.5 text-sm font-normal text-left rtl:text-right text-gray-500 dark:text-gray-400"
                    >
                      <button class="flex items-center gap-x-2">
                        <span>Description</span>

                        <svg
                          class="h-3"
                          viewBox="0 0 10 11"
                          fill="none"
                          xmlns="http://www.w3.org/2000/svg"
                        >
                          <path
                            d="M2.13347 0.0999756H2.98516L5.01902 4.79058H3.86226L3.45549 3.79907H1.63772L1.24366 4.79058H0.0996094L2.13347 0.0999756ZM2.54025 1.46012L1.96822 2.92196H3.11227L2.54025 1.46012Z"
                            fill="currentColor"
                            stroke="currentColor"
                            stroke-width="0.1"
                          />
                          <path
                            d="M0.722656 9.60832L3.09974 6.78633H0.811638V5.87109H4.35819V6.78633L2.01925 9.60832H4.43446V10.5617H0.722656V9.60832Z"
                            fill="currentColor"
                            stroke="currentColor"
                            stroke-width="0.1"
                          />
                          <path
                            d="M8.45558 7.25664V7.40664H8.60558H9.66065C9.72481 7.40664 9.74667 7.42274 9.75141 7.42691C9.75148 7.42808 9.75146 7.42993 9.75116 7.43262C9.75001 7.44265 9.74458 7.46304 9.72525 7.49314C9.72522 7.4932 9.72518 7.49326 9.72514 7.49332L7.86959 10.3529L7.86924 10.3534C7.83227 10.4109 7.79863 10.418 7.78568 10.418C7.77272 10.418 7.73908 10.4109 7.70211 10.3534L7.70177 10.3529L5.84621 7.49332C5.84617 7.49325 5.84612 7.49318 5.84608 7.49311C5.82677 7.46302 5.82135 7.44264 5.8202 7.43262C5.81989 7.42993 5.81987 7.42808 5.81994 7.42691C5.82469 7.42274 5.84655 7.40664 5.91071 7.40664H6.96578H7.11578V7.25664V0.633865C7.11578 0.42434 7.29014 0.249976 7.49967 0.249976H8.07169C8.28121 0.249976 8.45558 0.42434 8.45558 0.633865V7.25664Z"
                            fill="currentColor"
                            stroke="currentColor"
                            stroke-width="0.3"
                          />
                        </svg>
                      </button>
                    </th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200 dark:divide-gray-700 dark:bg-gray-900">
                  <%= for sport <- @sports do %>
                    <tr class="cursor-pointer hover:bg-gray-100">
                      <td class="px-4 py-4 text-sm font-medium text-gray-700 whitespace-nowrap">
                        <div class="inline-flex items-center gap-x-3">
                          <div class="flex items-center gap-x-2">
                            <div>
                              <h2 class="font-medium text-gray-800 dark:text-white ">
                                <%= sport.name %>
                              </h2>
                            </div>
                          </div>
                        </div>
                      </td>
                      <td class="px-12 py-4 text-sm text-gray-500 dark:text-gray-300 whitespace-nowrap">
                        <%= sport.description %>
                      </td>
                      <td class="px-4 py-4 text-sm whitespace-nowrap">
                        <div class="flex items-center gap-x-6">
                          <button class="text-gray-500 transition-colors duration-200 dark:hover:text-blue-500 dark:text-gray-300 hover:text-blue-500 focus:outline-none">
                            <svg
                              xmlns="http://www.w3.org/2000/svg"
                              fill="none"
                              viewBox="0 0 24 24"
                              stroke-width="1.5"
                              stroke="currentColor"
                              class="w-5 h-5"
                            >
                              <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0115.75 21H5.25A2.25 2.25 0 013 18.75V8.25A2.25 2.25 0 015.25 6H10"
                              />
                            </svg>
                          </button>
                        </div>
                      </td>
                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </section>

    <%!-- Matches --%>

    <section class="container px-4 mx-auto mt-16">
      <div class="flex justify-between">
        <div class="flex items-center gap-x-3">
          <h2 class="text-lg font-medium text-gray-800 dark:text-white">
            Matches
          </h2>
          <span class="px-3 py-1 text-xs text-blue-600 bg-blue-100 rounded-full dark:bg-gray-800 dark:text-blue-400">
            <%= Enum.count(@matches) %> matches
          </span>
        </div>
        <.modal id="new_match">
          <h1>New Match</h1>
          <.simple_form :let={f} for={@match_changeset} phx-submit="create_match">
            <.input field={f[:home]} type="text" label="Home" required />
            <.input field={f[:away]} type="text" label="Away" required />
            <.input field={f[:starts]} type="datetime-local" label="Starts" required />
            <.input field={f[:ends]} type="datetime-local" label="Ends" required />
            <.input
              field={f[:status]}
              type="select"
              label="Status"
              options={["pending", "completed", "cancelled"]}
              required
            />
            <.input
              type="select"
              prompt="Sport"
              field={f[:sport_id]}
              label="Sport"
              options={Enum.map(@sports, &{&1.name, &1.id})}
              required
            />

            <.button
              type="submit"
              phx-disable-with="Creating match..."
              phx-click={hide_modal("new_match")}
            >
              Create match
            </.button>
          </.simple_form>
        </.modal>
        <button
          class="text-white px-4 py-2 bg-blue-500 rounded-lg float-right flex"
          phx-click={show_modal("new_match")}
          phx-target="new_match"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            class="w-6 h-6"
          >
            <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
          </svg>
          New Match
        </button>
      </div>
      <div class="flex flex-col mt-6">
        <div class="-mx-4 -my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
          <div class="inline-block min-w-full py-2 align-middle md:px-6 lg:px-8">
            <div class="overflow-hidden border border-gray-200 dark:border-gray-700 md:rounded-lg">
              <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
                <thead class="bg-gray-50 dark:bg-gray-800">
                  <tr>
                    <th
                      scope="col"
                      class="py-3.5 px-4 text-sm font-normal text-left rtl:text-right text-gray-500 dark:text-gray-400"
                    >
                      <div class="flex items-center gap-x-3">
                        <span>Home</span>
                      </div>
                    </th>

                    <th
                      scope="col"
                      class="px-12 py-3.5 text-sm font-normal text-left rtl:text-right text-gray-500 dark:text-gray-400"
                    >
                      <button class="flex items-center gap-x-2">
                        <span>Away</span>

                        <svg
                          class="h-3"
                          viewBox="0 0 10 11"
                          fill="none"
                          xmlns="http://www.w3.org/2000/svg"
                        >
                          <path
                            d="M2.13347 0.0999756H2.98516L5.01902 4.79058H3.86226L3.45549 3.79907H1.63772L1.24366 4.79058H0.0996094L2.13347 0.0999756ZM2.54025 1.46012L1.96822 2.92196H3.11227L2.54025 1.46012Z"
                            fill="currentColor"
                            stroke="currentColor"
                            stroke-width="0.1"
                          />
                          <path
                            d="M0.722656 9.60832L3.09974 6.78633H0.811638V5.87109H4.35819V6.78633L2.01925 9.60832H4.43446V10.5617H0.722656V9.60832Z"
                            fill="currentColor"
                            stroke="currentColor"
                            stroke-width="0.1"
                          />
                          <path
                            d="M8.45558 7.25664V7.40664H8.60558H9.66065C9.72481 7.40664 9.74667 7.42274 9.75141 7.42691C9.75148 7.42808 9.75146 7.42993 9.75116 7.43262C9.75001 7.44265 9.74458 7.46304 9.72525 7.49314C9.72522 7.4932 9.72518 7.49326 9.72514 7.49332L7.86959 10.3529L7.86924 10.3534C7.83227 10.4109 7.79863 10.418 7.78568 10.418C7.77272 10.418 7.73908 10.4109 7.70211 10.3534L7.70177 10.3529L5.84621 7.49332C5.84617 7.49325 5.84612 7.49318 5.84608 7.49311C5.82677 7.46302 5.82135 7.44264 5.8202 7.43262C5.81989 7.42993 5.81987 7.42808 5.81994 7.42691C5.82469 7.42274 5.84655 7.40664 5.91071 7.40664H6.96578H7.11578V7.25664V0.633865C7.11578 0.42434 7.29014 0.249976 7.49967 0.249976H8.07169C8.28121 0.249976 8.45558 0.42434 8.45558 0.633865V7.25664Z"
                            fill="currentColor"
                            stroke="currentColor"
                            stroke-width="0.3"
                          />
                        </svg>
                      </button>
                    </th>

                    <th
                      scope="col"
                      class="px-4 py-3.5 text-sm font-normal text-left rtl:text-right text-gray-500 dark:text-gray-400"
                    >
                      <button class="flex items-center gap-x-2">
                        <span>Start time</span>

                        <svg
                          xmlns="http://www.w3.org/2000/svg"
                          fill="none"
                          viewBox="0 0 24 24"
                          stroke-width="2"
                          stroke="currentColor"
                          class="w-4 h-4"
                        >
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            d="M9.879 7.519c1.171-1.025 3.071-1.025 4.242 0 1.172 1.025 1.172 2.687 0 3.712-.203.179-.43.326-.67.442-.745.361-1.45.999-1.45 1.827v.75M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-9 5.25h.008v.008H12v-.008z"
                          />
                        </svg>
                      </button>
                    </th>

                    <th
                      scope="col"
                      class="px-4 py-3.5 text-sm font-normal text-left rtl:text-right text-gray-500 dark:text-gray-400"
                    >
                      End time
                    </th>
                    <th
                      scope="col"
                      class="px-6 py-3.5 text-sm font-normal text-left rtl:text-right text-gray-500 dark:text-gray-400"
                    >
                      Sport
                    </th>

                    <th
                      scope="col"
                      class="px-6 py-3.5 text-sm font-normal text-left rtl:text-right text-gray-500 dark:text-gray-400"
                    >
                      Status
                    </th>

                    <th scope="col" class="relative py-3.5 px-4">
                      <span class="sr-only">Edit</span>
                    </th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200 dark:divide-gray-700 dark:bg-gray-900">
                  <%= for match <- @matches do %>
                    <.modal id={"configure_match_#{match.id}"}>
                      <h1>Configure match odds</h1>
                      <.simple_form :let={f} for={@odd_changeset} phx-submit="configure_odds">
                        <.input field={f[:match_id]} type="hidden" value={match.id} />
                        <div class="flex justify-around gap-2">
                          <.input
                            field={f[:home]}
                            type="number"
                            step="0.1"
                            label="Home"
                            value={get_odd_value(match.odds, "home")}
                            required
                          />
                          <.input
                            field={f[:draw]}
                            type="number"
                            label="Draw"
                            min="0"
                            step="0.1"
                            value={get_odd_value(match.odds, "draw")}
                            required
                          />
                          <.input
                            field={f[:away]}
                            type="number"
                            step="0.1"
                            label="Away"
                            value={get_odd_value(match.odds, "away")}
                            required
                          />
                        </div>
                        <.button type="submit" phx-click={hide_modal("configure_match_#{match.id}")}>
                          Configure odds
                        </.button>
                      </.simple_form>
                    </.modal>
                    <.modal id={"edit_match_#{match.id}"}>
                      <h1>Edit match</h1>
                      <.simple_form
                        :let={f}
                        for={Sports.Match.changeset(match, %{})}
                        phx-submit="update_match"
                      >
                        <.input field={f[:home]} type="text" label="Home" required />
                        <.input field={f[:away]} type="text" label="Away" required />
                        <.input field={f[:starts]} type="datetime-local" label="Starts" required />
                        <.input field={f[:ends]} type="datetime-local" label="Ends" required />
                        <.input
                          field={f[:status]}
                          type="select"
                          label="Status"
                          options={["pending", "completed", "cancelled"]}
                          required
                        />
                        <.input
                          type="select"
                          prompt="Sport"
                          field={f[:sport_id@match_changeset]}
                          label="Sport"
                          options={Enum.map(@sports, &{&1.name, &1.id})}
                          required
                        />
                        <.button type="submit">
                          Update match
                        </.button>
                      </.simple_form>
                    </.modal>
                    <.modal id={"delete_match_#{match.id}"}>
                      <h1>Delete match</h1>
                      <p class="my-4 text-xl font-regular">
                        Are you sure you want to delete this match?
                      </p>
                      <button
                        class="bg-red-500 border-none px-4 py-2 outline-none text-white rounded-lg"
                        phx-click="delete_match"
                        phx-value-id={match.id}
                      >
                        Delete match
                      </button>
                    </.modal>
                    <tr
                      class="cursor-pointer hover:bg-gray-100 cursor-pointer has-tooltip"
                      phx-click={show_modal("configure_match_#{match.id}")}
                    >
                      <td class="px-4 py-4 text-sm font-medium text-gray-700 whitespace-nowrap">
                        <div class="inline-flex items-center gap-x-3">
                          <div class="flex items-center gap-x-2">
                            <div>
                              <h2 class="font-regular text-gray-800 dark:text-white ">
                                <%= match.home %>
                              </h2>
                            </div>
                          </div>
                        </div>
                      </td>
                      <td class="px-12 py-4 text-sm font-medium text-gray-700 whitespace-nowrap">
                        <div class="inline-flex items-center gap-x-3">
                          <div class="flex items-center gap-x-2">
                            <div>
                              <h2 class="font-regular text-gray-800 dark:text-white ">
                                <%= match.away %>
                              </h2>
                            </div>
                          </div>
                        </div>
                      </td>
                      <td class="px-4 py-4 text-sm text-gray-500 dark:text-gray-300 whitespace-nowrap">
                        <%= to_local_time(match.starts) %>
                      </td>
                      <td class="px-4 py-4 text-sm text-gray-500 dark:text-gray-300 whitespace-nowrap">
                        <%= to_local_time(match.ends) %>
                      </td>
                      <td class="px-4 py-4 text-sm text-gray-500 dark:text-gray-300 whitespace-nowrap">
                        <span class="px-3 py-1 text-xs text-blue-600 bg-blue-100 rounded-full dark:bg-gray-800 dark:text-blue-400">
                          <%= match.sport.name %>
                        </span>
                      </td>
                      <td class="px-4 py-4 text-sm text-gray-500 dark:text-gray-300 whitespace-nowrap">
                        <%= case match.status do %>
                          <% "pending" -> %>
                            <span class="px-3 py-1 text-xs text-yellow-600 bg-yellow-100 rounded-full dark:bg-gray-800 dark:text-yellow-400">
                              <%= match.status %>
                            </span>
                          <% "completed" -> %>
                            <span class="px-3 py-1 text-xs text-green-600 bg-green-100 rounded-full dark:bg-gray-800 dark:text-green-400">
                              <%= match.status %>
                            </span>
                          <% "cancelled" -> %>
                            <span class="px-3 py-1 text-xs text-red-600 bg-red-100 rounded-full dark:bg-gray-800 dark:text-red-400">
                              <%= match.status %>
                            </span>
                        <% end %>
                      </td>
                      <td class="px-4 py-4 text-sm whitespace-nowrap">
                        <div class="flex items-center gap-x-6">
                          <button
                            class="text-gray-500 transition-colors duration-200 dark:hover:text-blue-500 dark:text-gray-300 hover:text-blue-500 focus:outline-none"
                            phx-click={show_modal("edit_match_#{match.id}")}
                            phx-value-id={match.id}
                          >
                            <svg
                              xmlns="http://www.w3.org/2000/svg"
                              fill="none"
                              viewBox="0 0 24 24"
                              stroke-width="1.5"
                              stroke="currentColor"
                              class="w-5 h-5"
                            >
                              <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0115.75 21H5.25A2.25 2.25 0 013 18.75V8.25A2.25 2.25 0 015.25 6H10"
                              />
                            </svg>
                          </button>
                          <button
                            class="text-gray-500 transition-colors duration-200 dark:hover:text-blue-500 dark:text-gray-300 hover:text-red-500 focus:outline-none"
                            phx-click={show_modal("delete_match_#{match.id}")}
                          >
                            <svg
                              xmlns="http://www.w3.org/2000/svg"
                              fill="none"
                              viewBox="0 0 24 24"
                              stroke-width="1.5"
                              stroke="currentColor"
                              class="w-6 h-6"
                            >
                              <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0"
                              />
                            </svg>
                          </button>
                        </div>
                      </td>
                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </section>
    """
  end

  @impl true
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_token(session["session"])

    case user do
      nil -> {:error, redirect(to: "/login")}
      _ -> {:ok, assign(socket, user: user)}
    end

    sports = Sports.list_sports()
    matches = Sports.list_matches()

    match_changeset = Sports.Match.changeset(%Sports.Match{}, %{})
    odd_changeset = Placement.Odd.changeset(%Placement.Odd{}, %{})

    {:ok,
     assign(socket,
       sports: sports,
       matches: matches,
       match_changeset: match_changeset,
       odd_changeset: odd_changeset
     )}
  end

  def handle_event("delete_match", %{"id" => id}, socket) do
    match = Sports.get_match!(id)
    IO.inspect(match, label: "Match")

    case Sports.delete_match(match) do
      {:ok, _} ->
        case Sports.list_matches() do
          [] -> {:noreply, assign(socket, matches: [])}
          matches -> {:noreply, assign(socket, matches: matches)}
        end

      {:error, _} ->
        {:noreply, socket}
    end
  end

  def handle_event("configure_odds", %{"odd" => odds}, socket) do
    # {:noreply, socket}

    # params %{"away" => "0.0", "draw" => "0.0", "home" => "0.0"}
    # create the odds and associate them with the match

    match_id = odds["match_id"]

    # home odd
    home = %{
      "name" => "home",
      "status" => "active",
      "odd" => odds["home"],
      "match_id" => match_id
    }

    # draw odd
    draw = %{
      "name" => "draw",
      "status" => "active",
      "odd" => odds["draw"],
      "match_id" => match_id
    }

    # away odd
    away = %{
      "name" => "away",
      "status" => "active",
      "odd" => odds["away"],
      "match_id" => match_id
    }

    with {:ok, _} <- Placement.create_odd(home),
         {:ok, _} <- Placement.create_odd(draw),
         {:ok, _} <- Placement.create_odd(away) do
      {:noreply,
       socket
       |> put_flash(:info, "Odd configuration success")
       |> assign(matches: Sports.list_matches())}
    else
      {:error, changeset} ->
        {:noreply, assign(socket, odd_changeset: changeset)}
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event("create_match", %{"match" => match_params}, socket) do
    match_params =
      case DateTime.now("Etc/UTC") do
        {:ok, now} -> Map.put(match_params, "date", now)
      end

    tz_db = Calendar.get_time_zone_database()
    IO.inspect(tz_db)

    {:ok, starts} = NaiveDateTime.from_iso8601(match_params["starts"] <> ":00")
    {:ok, d} = DateTime.from_naive(starts, "Africa/Nairobi")
    {:ok, st} = DateTime.shift_zone(d, "Etc/UTC")

    {:ok, ends} = NaiveDateTime.from_iso8601(match_params["ends"] <> ":00")
    {:ok, d} = DateTime.from_naive(ends, "Africa/Nairobi")
    {:ok, et} = DateTime.shift_zone(d, "Etc/UTC")

    match_params =
      match_params
      |> Map.put("starts", st)
      |> Map.put("ends", et)

    case Sports.create_match(match_params) do
      nil ->
        {:noreply, socket}

      _ ->
        case Sports.list_matches() do
          [] ->
            {:noreply, assign(socket, matches: [])}

          matches ->
            {:noreply,
             assign(socket,
               matches: matches,
               match_changeset: Sports.Match.changeset(%Sports.Match{}, %{})
             )}
        end
    end
  end

  defp get_odd_value(odds, key) do
    case odds do
      [] ->
        0.0

      _ ->
        odds
        |> Enum.find(&(&1.name == key))
        |> Map.get(:odd)
    end
  end

  defp to_local_time(t) do
    case DateTime.shift_zone(t, "Africa/Nairobi") do
      {:ok, dt} -> dt
      {:error, _} -> t
    end
  end
end
