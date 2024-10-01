defmodule GalaxyWeb.CommentHTML do
  @moduledoc """
  This module contains templates for rendering comments.

  See the `comment_html` directory for all templates available.
  """
  use GalaxyWeb, :html

  embed_templates "comment_html/*"
end
