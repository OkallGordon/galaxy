defmodule GalaxyWeb.AnnotationHTML do
  use GalaxyWeb, :html

  def render("annotation.json", %{annotation: annotation}) do
    %{
      body: annotation.body,
      comment: annotation.comment,
      at: annotation.at,
      user_email: annotation.user.email  # Include user details if needed
    }
  end
end
