defmodule GalaxyWeb.VideoChannel do
  use Phoenix.Channel

  def join("videos:" <> video_id, _params, socket) do
    {:ok, assign(socket, :video_id, video_id)}
  end

  def handle_in("new_annotation", %{"body" => body, "comment" => comment, "at" => at}, socket) do
    current_user = socket.assigns[:current_user]

    if current_user do
      # Proceed with creating the annotation
      # Example: Multimedia.create_annotation(%{body: body, comment: comment, at: at, user_id: current_user.id})

      # Broadcast the new annotation to the channel
      broadcast(socket, "new_annotation", %{
        body: body,
        comment: comment,
        at: at,
        user: %{email: current_user.email}  # Adjust this if you want more user details
      })

      {:noreply, socket}
    else
      {:reply, {:error, "User not authenticated"}, socket}
    end
  end
end
