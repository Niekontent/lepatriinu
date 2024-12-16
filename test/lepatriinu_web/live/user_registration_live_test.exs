defmodule LepatriinuWeb.UserRegistrationLiveTest do
  use LepatriinuWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Lepatriinu.AccountsFixtures

  describe "Registration page" do
    test "renders registration page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/users/register")

      assert html =~ "Register"
      assert html =~ "Log in"
    end

    test "redirects if already logged in", %{conn: conn} do
      result =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/users/register")
        |> follow_redirect(conn, "/polls")

      assert {:ok, _conn} = result
    end
  end

  describe "register user" do
    test "creates account and logs the user in", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      name = unique_user_name()
      form = form(lv, "#registration_form", user: valid_user_attributes(name: name))
      render_submit(form)
      conn = follow_trigger_action(form, conn)

      assert redirected_to(conn) == ~p"/polls"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ name
      assert response =~ "Log out"
    end
  end
end
