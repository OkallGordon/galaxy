defmodule Galaxy.TopicsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Galaxy.Topics` context.
  """

  @doc """
  Generate a topic.
  """
  def topic_fixture(attrs \\ %{}) do
    {:ok, topic} =
      attrs
      |> Enum.into(%{
        summary: "some summary"
      })
      |> Galaxy.Topics.create_topic()

    topic
  end
end
