defmodule Galaxy.TestHelpers do
  alias Galaxy.{
    Accounts,
    Multimedia
  }

  def user_fixture(attrs \\ %{}) do
    # Ensure a valid email format by adding an "@" character
    email = "user#{System.unique_integer([:positive])}@example.com"

    attrs
    |> Enum.into(%{
      name: "Some User",
      email: email,  # Use a valid email format
      password: attrs[:password] || "supersecret"
    })
    |> Accounts.register_user()
    |> case do
      {:ok, user} -> user
      {:error, changeset} -> raise "Failed to create user: #{inspect(changeset)}"
    end
  end
  def video_fixture(%Accounts.User{} = user, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        title: "A Title",
        url: "http://example.com",
        description: "a description"
      })

      {:ok, video} = Multimedia.create_video(user, attrs)

      video
  end
end
