defmodule GalaxyWeb.UserSocket do
  use Phoenix.Socket

  channel "videos:*", GalaxyWeb.VideoChannel

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
