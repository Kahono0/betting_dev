defmodule Bet.Email do
  import Bamboo.Email

  def welcome_email(email) do
    new_email()
    |> from("kahono@kahono")
    |> to(email)
    |> subject("Welcome to Bet!")
    |> text_body("Welcome to Bet!")
    |> html_body("<strong>Welcome to Bet!</strong>")
  end

  def won_email(email, slip_string) do
    new_email()
    |> from("kahono@kahono")
    |> to(email)
    |> subject("Bet Won!!!")
    |> text_body("You have won a bet.\n #{slip_string}")
    |> html_body("<strong>You won have won a bet.<br/> #{slip_string}</strong>")
  end

  def lost_email(email, slip_string) do
    new_email()
    |> from("kahono@kahono")
    |> to(email)
    |> subject("Bet Lost")
    |> text_body("You have lost a bet.\n #{slip_string}")
    |> html_body("<strong>You have lost a bet.<br/> #{slip_string}</strong>")
  end
end
