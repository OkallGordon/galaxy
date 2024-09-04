defmodule GalaxyWeb.VideoHTML do
  use GalaxyWeb, :html

  embed_templates "video_html/*"

  @doc """
  Renders a video form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def video_form(assigns)
end
