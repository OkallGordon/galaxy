defmodule Galaxy.AccountsTest do
  use Galaxy.DataCase, async: true

  alias Galaxy.Accounts
  alias Galaxy.Accounts.User

  describe "register_user/1" do
    @valid_attrs %{
      name: "User",
      email: "user@example.com",
      password: "secret"
    }
    @invalid_attrs %{}

    test "with valid data insert user" do
      assert {:ok, %User{id: id}=user} = Accounts.register_user(@valid_attrs)
      assert user.name == "User"
      assert user.email == "user@example.com"
      assert [%User{id: ^id}] = Accounts.list_users()
    end

   test "with invalid data does not insert user" do
     assert {:error, _changeset} = Accounts.register_user(@invalid_attrs)
     assert Accounts.list_users() == []
   end

   test "enforces unique email" do
    assert {:ok, %User{id: id}} = Accounts.register_user(@valid_attrs)
    assert {:error, changeset} = Accounts.register_user(@valid_attrs)

    assert %{email: ["has been taken"]} =
            errors_on(changeset)
    assert [%User{id: ^id}] = Accounts.list_users()
   end

    test "does not accept long emails" do
      attrs = %{name: "User", email: String.duplicate("a", 21) <> "@example.com", password: "secret"}
     changeset = Accounts.register_user(attrs) |> elem(1)

      # Check only for the length error, ignoring format
      assert %{
      email: ["should be at most 20 character(s)"]
       } = errors_on(changeset)
   end

    test "requires password to be at least 6 chars long" do
      attrs = Map.put(@valid_attrs, :password, "12345")
      {:error, changeset} = Accounts.register_user(attrs)

    assert %{password: ["should be at least 6 character(s)"]} =
      errors_on(changeset)
      assert Accounts.list_users() == []
    end
  end
end
