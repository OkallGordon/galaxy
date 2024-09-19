defmodule GalaxyWeb.VideoChannel do
  use Phoenix.Channel

  def join("videos:" <> video_id, _params, socket) do
    {:ok, assign(socket, :video_id, video_id)}
  end

  def handle_in("new_annotation", %{"body" => body, "comment" => comment, "at" => at}, socket) do
    # Process and store the annotation and comment
    broadcast(socket, "new_annotation", %{
      body: body,
      comment: comment,
      at: at,
      user: socket.assigns.current_user
    })
    {:noreply, socket}
  end
end
