defmodule BetWeb.AdminLive.Index do
  use Phoenix.LiveView, layout: {BetWeb.Layouts, :admin}
  use BetWeb, :verified_routes
  import BetWeb.CoreComponents

  alias Phoenix.LiveView.JS
  alias Bet.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <section class="container px-4 mx-auto">
      <div class="flex justify-between">
        <div class="flex items-center gap-x-3">
          <h2 class="text-lg font-medium text-gray-800 dark:text-white">
            Users
          </h2>
          <span class="px-3 py-1 text-xs text-blue-600 bg-blue-100 rounded-full dark:bg-gray-800 dark:text-blue-400">
            <%= @user_count %> users
          </span>
        </div>
        <.modal id="new_user">
          <h1>New User</h1>
          <.simple_form :let={f} for={@user_changeset} phx-submit="create_user">
            <.input field={f[:first_name]} type="text" label="first name" />
            <.input field={f[:last_name]} type="text" label="last name" />
            <.input field={f[:email]} type="email" label="email" />
            <.input field={f[:msisdn]} type="tel" label="msisdn" />
            <.input field={f[:password]} type="password" label="password" />
            <.input
              type="select"
              prompt="Role"
              field={f[:role_id]}
              label="Role"
              options={Enum.map(@roles, &{&1.name, &1.id})}
              required
            />
            <.button type="submit">
              Create user
            </.button>
          </.simple_form>
        </.modal>
        <button
          class="text-white px-4 py-2 bg-blue-500 rounded-lg float-right flex"
          phx-click={show_modal("new_user")}
          phx-target="new_user"
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
          New User
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
                        <span>Status</span>

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
                        <span>Role</span>

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
                      Email address
                    </th>
                    <th
                      scope="col"
                      class="px-4 py-3.5 text-sm font-normal text-left rtl:text-right text-gray-500 dark:text-gray-400"
                    >
                      Msisdn
                    </th>

                    <th scope="col" class="relative py-3.5 px-4">
                      <span class="sr-only">Edit</span>
                    </th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200 dark:divide-gray-700 dark:bg-gray-900">
                  <%= for user <- @users do %>
                    <.modal id={"edit_user_#{user.id}"}>
                      <h1>Edit User</h1>
                      <.simple_form
                        :let={f}
                        for={get_edit_user_changeset(user)}
                        phx-submit="update_user"
                        phx-value-id={user.id}
                      >
                        <.input field={f[:first_name]} type="text" label="first name" />
                        <.input field={f[:last_name]} type="text" label="last name" />
                        <.input field={f[:email]} type="email" label="email" />
                        <.input field={f[:msisdn]} type="tel" label="msisdn" />
                        <.input
                          type="select"
                          prompt="Role"
                          field={f[:role_id]}
                          label="Role"
                          options={Enum.map(@roles, &{&1.name, &1.id})}
                          required
                        />
                        <%= if user.role do %>
                          <%= if user.role.name == "admin" do %>
                            <.button phx-click="revoke_admin" phx-value-id={user.id}>
                              Revoke admin
                            </.button>
                          <% end %>
                        <% end %>
                        <.button type="submit" phx-click={hide_modal("edit_user_#{user.id}")}>
                          Update user
                        </.button>
                      </.simple_form>
                    </.modal>
                    <tr
                      class="cursor-pointer hover:bg-gray-100"
                      phx-click={JS.patch(~p"/admin/bets/#{user.id}/")}
                    >
                      <td class="px-4 py-4 text-sm font-medium text-gray-700 whitespace-nowrap">
                        <div class="inline-flex items-center gap-x-3">
                          <div class="flex items-center gap-x-2">
                            <div>
                              <h2 class="font-medium text-gray-800 dark:text-white ">
                                <%= user.first_name <> " " <> user.last_name %>
                              </h2>
                            </div>
                          </div>
                        </div>
                      </td>
                      <td class="px-12 py-4 text-sm font-medium text-gray-700 whitespace-nowrap">
                        <div class="inline-flex items-center px-3 py-1 rounded-full gap-x-2 bg-emerald-100/60 dark:bg-gray-800">
                          <span class="h-1.5 w-1.5 rounded-full bg-emerald-500"></span>

                          <h2 class="text-sm font-normal text-emerald-500">Active</h2>
                        </div>
                      </td>
                      <td class="px-4 py-4 text-sm text-gray-500 dark:text-gray-300 whitespace-nowrap">
                        <%= if user.role do %>
                          <%= user.role.name %>
                        <% end %>
                      </td>
                      <td class="px-4 py-4 text-sm text-gray-500 dark:text-gray-300 whitespace-nowrap">
                        <%= user.email %>
                      </td>
                      <td class="px-4 py-4 text-sm text-gray-500 dark:text-gray-300 whitespace-nowrap">
                        <%= user.msisdn %>
                      </td>
                      <td class="px-4 py-4 text-sm whitespace-nowrap">
                        <div class="flex items-center gap-x-6">
                          <button
                            class="text-gray-500 transition-colors duration-200 dark:hover:text-blue-500 dark:text-gray-300 hover:text-blue-500 focus:outline-none"
                            phx-click={show_modal("edit_user_#{user.id}")}
                            phx-target={user.id}
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
                            phx-click="delete_user"
                            phx-value-id={user.id}
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
    <!-- Roles -->
    <section class="container px-4 mx-auto mt-16">
      <div class="flex justify-between">
        <div class="flex items-center gap-x-3">
          <h2 class="text-lg font-medium text-gray-800 dark:text-white">
            Roles
          </h2>
          <span class="px-3 py-1 text-xs text-blue-600 bg-blue-100 rounded-full dark:bg-gray-800 dark:text-blue-400">
            <%= @role_count %> roles
          </span>
        </div>
        <.modal id="new_role">
          <h1>New Role</h1>
          <.simple_form :let={f} for={@role_changeset} phx-submit="create_role">
            <.input field={f[:name]} label="Name" required />
            <.button type="submit">
              Create role
            </.button>
          </.simple_form>
        </.modal>
        <button
          class="text-white px-4 py-2 bg-blue-500 rounded-lg float-right flex"
          phx-click={show_modal("new_role")}
          phx-target="new_role"
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
          New role
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
                        <span>Status</span>

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
                        <span>Users with role</span>

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
                      <button class="flex items-center gap-x-2">
                        <span>Permissions</span>

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

                    <th scope="col" class="relative py-3.5 px-4">
                      <span class="sr-only">Edit</span>
                    </th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200 dark:divide-gray-700 dark:bg-gray-900">
                  <%= for role <- @roles do %>
                    <.modal id={"edit_role_#{role.id}"}>
                      <h1>Edit Role</h1>
                      <.simple_form
                        :let={f}
                        for={get_edit_role_changeset(role)}
                        phx-submit="update_role"
                        phx-value-id={role.id}
                      >
                        <.input field={f[:name]} label="Name" required />
                        <.button type="submit" phx-click={hide_modal("edit_role_#{role.id}")}>
                          Update role
                        </.button>
                      </.simple_form>
                    </.modal>
                    <tr class="cursor-pointer hover:bg-gray-100">
                      <td class="px-4 py-4 text-sm font-medium text-gray-700 whitespace-nowrap">
                        <div class="inline-flex items-center gap-x-3">
                          <div class="flex items-center gap-x-2">
                            <div>
                              <h2 class="font-medium text-gray-800 dark:text-white ">
                                <%= role.name %>
                              </h2>
                            </div>
                          </div>
                        </div>
                      </td>
                      <td class="px-12 py-4 text-sm font-medium text-gray-700 whitespace-nowrap">
                        <div class="inline-flex items-center px-3 py-1 rounded-full gap-x-2 bg-emerald-100/60 dark:bg-gray-800">
                          <span class="h-1.5 w-1.5 rounded-full bg-emerald-500"></span>

                          <h2 class="text-sm font-normal text-emerald-500">Active</h2>
                        </div>
                      </td>
                      <td class="px-4 py-4 text-sm text-gray-500 dark:text-gray-300 whitespace-nowrap">
                        <span class="px-3 py-1 text-xs text-blue-600 bg-blue-100 rounded-full dark:bg-gray-800 dark:text-blue-400">
                          <%= Enum.count(role.users) %> user(s)
                        </span>
                      </td>
                      <td class="px-4 py-4 text-sm text-gray-500 dark:text-gray-300 whitespace-nowrap">
                        <span class="px-3 py-1 text-xs text-yello-600 bg-yellow-100 rounded-full dark:bg-yellow-800 dark:yellow-blue-400">
                          <%= Enum.count(role.permissions) %> permission(s)
                        </span>
                      </td>
                      <td class="px-4 py-4 text-sm whitespace-nowrap">
                        <div class="flex items-center gap-x-6">
                          <button
                            class="text-gray-500 transition-colors duration-200 dark:hover:text-blue-500 dark:text-gray-300 hover:text-blue-500 focus:outline-none"
                            phx-click={show_modal("edit_role_#{role.id}")}
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
                            phx-click="delete_role"
                            phx-value-id={role.id}
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
    <!-- Permisions -->
    <section class="container px-4 mx-auto mt-16">
      <div class="flex justify-between">
        <div class="flex items-center gap-x-3">
          <h2 class="text-lg font-medium text-gray-800 dark:text-white">
            Permissions
          </h2>
          <span class="px-3 py-1 text-xs text-blue-600 bg-blue-100 rounded-full dark:bg-gray-800 dark:text-blue-400">
            <%= @permission_count %> permissions
          </span>
        </div>
        <.modal id="new_permission">
          <h1>New permission</h1>
          <.simple_form :let={f} for={@permission_changeset} phx-submit="create_permission">
            <.input field={f[:name]} label="Name" required />
            <.input
              type="select"
              prompt="Belongs to"
              field={f[:role_id]}
              label="Role"
              options={Enum.map(@roles, &{&1.name, &1.id})}
              required
            />
            <.button type="submit">
              Create permission
            </.button>
          </.simple_form>
        </.modal>
        <button
          class="text-white px-4 py-2 bg-blue-500 rounded-lg float-right flex"
          phx-click={show_modal("new_permission")}
          phx-target="new_permission"
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
          New permission
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
                        <span>Status</span>

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
                        <span>Belongs to</span>

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

                    <th scope="col" class="relative py-3.5 px-4">
                      <span class="sr-only">Edit</span>
                    </th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200 dark:divide-gray-700 dark:bg-gray-900">
                  <%= for permission <- @permissions do %>
                    <.modal id={"edit_permission_#{permission.id}"}>
                      <h1>Edit Permission</h1>
                      <.simple_form
                        :let={f}
                        for={get_edit_permission_changeset(permission)}
                        phx-submit="update_permission"
                        phx-value-id={permission.id}
                      >
                        <.input field={f[:name]} type="text" label="Name" />
                        <.input
                          type="select"
                          prompt="Belongs to"
                          field={f[:role_id]}
                          label="Role"
                          options={Enum.map(@roles, &{&1.name, &1.id})}
                          required
                        />
                        <.button
                          type="submit"
                          phx-click={hide_modal("edit_permission_#{permission.id}")}
                        >
                          Update permission
                        </.button>
                      </.simple_form>
                    </.modal>
                    <tr class="cursor-pointer hover:bg-gray-100">
                      <td class="px-4 py-4 text-sm font-medium text-gray-700 whitespace-nowrap">
                        <div class="inline-flex items-center gap-x-3">
                          <div class="flex items-center gap-x-2">
                            <div>
                              <h2 class="font-medium text-gray-800 dark:text-white ">
                                <%= permission.name %>
                              </h2>
                            </div>
                          </div>
                        </div>
                      </td>
                      <td class="px-12 py-4 text-sm font-medium text-gray-700 whitespace-nowrap">
                        <div class="inline-flex items-center px-3 py-1 rounded-full gap-x-2 bg-emerald-100/60 dark:bg-gray-800">
                          <span class="h-1.5 w-1.5 rounded-full bg-emerald-500"></span>

                          <h2 class="text-sm font-normal text-emerald-500">Active</h2>
                        </div>
                      </td>
                      <td class="px-4 py-4 text-sm text-gray-500 dark:text-gray-300 whitespace-nowrap">
                        <span class="px-3 py-1 text-xs text-blue-600 bg-blue-100 rounded-full dark:bg-gray-800 dark:text-blue-400">
                          <%= permission.role.name %>
                        </span>
                      </td>
                      <td class="px-4 py-4 text-sm whitespace-nowrap">
                        <div class="flex items-center gap-x-6">
                          <button
                            class="text-gray-500 transition-colors duration-200 dark:hover:text-blue-500 dark:text-gray-300 hover:text-blue-500 focus:outline-none"
                            phx-click={show_modal("edit_permission_#{permission.id}")}
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
                            phx-click="delete_permission"
                            phx-value-id={permission.id}
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
  def mount(_params, _session, socket) do
    all_users = Accounts.list_users()
    user_count = Enum.count(all_users)
    roles = Accounts.list_roles()
    role_count = Enum.count(roles)
    permissions = Accounts.list_permissions()
    permission_count = Enum.count(permissions)

    user_changeset = Accounts.User.changeset(%Accounts.User{}, %{})
    role_changeset = Accounts.Role.changeset(%Accounts.Role{}, %{})
    permission_changeset = Accounts.Permission.changeset(%Accounts.Permission{}, %{})

    {:ok,
     assign(socket,
       users: all_users,
       user_count: user_count,
       roles: roles,
       role_count: role_count,
       permissions: permissions,
       permission_count: permission_count,
       user_changeset: user_changeset,
       role_changeset: role_changeset,
       permission_changeset: permission_changeset,
       hide_modals: false
     )}
  end

  @impl true
  def handle_event("create_permission", %{"permission" => params}, socket) do
    case Accounts.create_permission(params) do
      {:ok, permission} ->
        # update the ui with the new permission
        {:reply, {:ok, permission},
         assign(socket,
           permissions: [permission | socket.assigns.permissions],
           permission_changeset: Accounts.Permission.changeset(%Accounts.Permission{}, %{})
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, permission_changeset: changeset)}
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event("create_role", %{"role" => params}, socket) do
    case Accounts.create_role(params) do
      {:ok, role} ->
        # update the ui with the new role
        {:reply, {:ok, role},
         assign(socket,
           roles: [role | socket.assigns.roles],
           role_changeset: Accounts.Role.changeset(%Accounts.Role{}, %{})
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, role_changeset: changeset)}
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event("create_user", %{"user" => params}, socket) do
    case Accounts.create_user(params) do
      {:ok, user} ->
        # update the ui with the new user
        {:noreply,
         assign(socket,
           users: [user | socket.assigns.users],
           user_changeset: Accounts.User.changeset(%Accounts.User{}, %{})
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, user_changeset: changeset)}
    end

    {:noreply, socket}
  end

  def handle_event("update_user", %{"id" => id, "user" => user_params}, socket) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, _} ->
        # update the ui with the new user
        {:noreply,
         assign(socket,
           users: Accounts.list_users()
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, user_changeset: changeset)}
    end
  end

  # soft delete a user
  def handle_event("delete_user", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)

    case Accounts.delete_user(user) do
      {:ok, _} ->
        # update the ui with the new user
        {:noreply,
         assign(socket,
           users: Accounts.list_users()
         )}

      {:error, _} ->
        {:noreply, socket}
    end
  end

  # revoke admin. remove user.role_id
  def handle_event("revoke_admin", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)

    case Accounts.revoke_admin(user) do
      {:ok, _} ->
        # update the ui with the new user
        {:noreply,
         assign(socket,
           users: Accounts.list_users()
         )}

      {:error, _} ->
        {:noreply, socket}
    end
  end

  # update role
  def handle_event("update_role", %{"id" => id, "role" => role_params}, socket) do
    role = Accounts.get_role!(id)

    case Accounts.update_role(role, role_params) do
      {:ok, _} ->
        # update the ui with the new role
        {:noreply,
         assign(socket,
           roles: Accounts.list_roles()
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, role_changeset: changeset)}
    end
  end

  # delete role
  def handle_event("delete_role", %{"id" => id}, socket) do
    role = Accounts.get_role!(id)

    case Accounts.delete_role(role) do
      {:ok, _} ->
        # update the ui with the new role
        {:noreply,
         assign(socket,
           roles: Accounts.list_roles()
         )}

      {:error, _} ->
        {:noreply, socket}
    end
  end

  def handle_event("update_permission", %{"id" => id, "permission" => permission_params}, socket) do
    permission = Accounts.get_permission!(id)

    case Accounts.update_permission(permission, permission_params) do
      {:ok, _} ->
        # update the ui with the new permission
        {:noreply,
         assign(socket,
           permissions: Accounts.list_permissions()
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, permission_changeset: changeset)}
    end
  end

  # delete a permission
  def handle_event("delete_permission", %{"id" => id}, socket) do
    permission = Accounts.get_permission!(id)

    case Accounts.delete_permission(permission) do
      {:ok, _} ->
        # update the ui with the new permission
        {:noreply,
         assign(socket,
           permissions: Accounts.list_permissions()
         )}

      {:error, _} ->
        {:noreply, socket}
    end
  end

  defp get_edit_user_changeset(user) do
    Accounts.User.changeset(user, %{})
  end

  defp get_edit_role_changeset(role) do
    Accounts.Role.changeset(role, %{})
  end

  defp get_edit_permission_changeset(permission) do
    Accounts.Permission.changeset(permission, %{})
  end
end
