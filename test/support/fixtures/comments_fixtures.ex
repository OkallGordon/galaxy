defmodule Galaxy.CommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Galaxy.Comments` context.
  """

  @doc """
  Generate a comment.
  """
  def comment_fixture(user, attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        comment: "some comment",
        topic: "some topic"
      })
      |> Galaxy.Comments.create_user_comment(user)  # Pass the user as the first argument

    comment
  end
end
