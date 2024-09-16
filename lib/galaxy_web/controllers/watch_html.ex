defmodule GalaxyWeb.WatchHTML do
  use GalaxyWeb, :html


  embed_templates "watch_html/*"

  def player_id(video) do
    ~r{^.*(?:youtu\.be/|\w+/|v=)(?<id>[^#&?]*)}
    |> Regex.named_captures(video.url)
    |> get_in(["id"])
  end
end
