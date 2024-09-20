defmodule GalaxyWeb.AnnotationController do
  use GalaxyWeb, :controller

  alias Galaxy.Multimedia


  def create(conn, %{"annotation" => annotation_params}, current_user) do
    # Create the annotation with the current user's ID
    attrs = Map.put(annotation_params, "user_id", current_user.id)

    case Multimedia.create_annotation(attrs) do
      {:ok, _annotation} ->
        conn
        |> put_flash(:info, "Annotation posted successfully.")
        |> redirect(to: ~p"/videos/#{annotation_params["video_id"]}")

      {:error, _reason} ->  # Handle the error
        video = Multimedia.get_user_video!(current_user, annotation_params["video_id"])  # Fetch the video
        conn
        |> put_flash(:error, "Failed to post annotation.")
        |> render("show.html", video: video)
    end
  end

end
