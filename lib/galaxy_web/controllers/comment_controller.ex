defmodule GalaxyWeb.CommentController do
  use GalaxyWeb, :controller

  alias Galaxy.Comments
  alias Galaxy.Comments.Comment
  alias Galaxy.Repo  # Ensure you have this alias
  alias Galaxy.Topics.Topic
  alias Galaxy.GeminiClient
  import Ecto.Query  # Import the Ecto Query module for using the `from` function

  def index(conn, _params) do
    current_user = get_current_user(conn)
    comments = Comments.list_user_comments(current_user)

    #Fetch the user's name
    user_name = current_user.name
    render(conn, "index.html", comments: comments, user_name: user_name)
  end

  defp get_current_user(conn) do
    conn.assigns[:current_user]
  end

  def new(conn, _params) do
    changeset = Comments.change_comment(%Comment{})
    users = Galaxy.Accounts.list_users()
    render(conn, "new.html", changeset: changeset, users: users)
  end

    def show(conn, %{"id" => id}) do
    current_user = get_current_user(conn)
    comment = Comments.get_user_comment!(current_user, id)
    render(conn, "show.html", comment: comment)
  end

  def create(conn, %{"comment" => comment_params}) do
    current_user = get_current_user(conn)

    # Exclude user_id from comment_params to prevent duplication
    comment_params = Map.drop(comment_params, ["user_id"])

    case Comments.create_user_comment(current_user, comment_params) do
      {:ok, comment} ->
        # Fetch all comments related to the same topic
        topic_comments = Repo.all(from c in Comment, where: c.topic == ^comment_params["topic"])

        # Extract the comment texts for summarization
        comment_texts = Enum.map(topic_comments, & &1.comment)

        # Send the comments to Gemini AI for summarization
        case GeminiClient.summarize_comments(comment_texts) do
          {:ok, summary} ->
            # Save the summary in the topic record
            topic = Repo.get!(Topic, comment_params["topic"])
            Repo.update!(Topic.changeset(topic, %{summary: summary}))

            # Redirect with a success message
            conn
            |> put_flash(:info, "Your comment has been created and the summary is updated.")
            |> redirect(to: ~p"/comments/#{comment.id}")

          {:error, reason} ->
            # Handle errors from the Gemini AI service
            conn
            |> put_flash(:error, "Failed to summarize comments: #{reason}")
            |> redirect(to: ~p"/comments/#{comment.id}")
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        users = Galaxy.Accounts.list_users()
        render(conn, "new.html", changeset: changeset, users: users)
    end
  end



    def edit(conn, %{"id" => id}) do
    current_user = get_current_user(conn)
    comment = Comments.get_user_comment!(current_user, id)
    changeset = Comments.change_comment(comment)
    users = Galaxy.Accounts.list_users()  # Fetch users to populate the select options
    render(conn, "edit.html", comment: comment, changeset: changeset, users: users)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    current_user = get_current_user(conn)
    comment = Comments.get_user_comment!(current_user, id)

    case Comments.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Your comment has been updated successfully.")
        |> redirect(to: ~p"/comments/#{comment.id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = get_current_user(conn)
    comment = Comments.get_user_comment!(current_user, id)
    {:ok, _comment} = Comments.delete_comment(comment)

    conn
    |> put_flash(:info, "Your comment has been deleted successfully.")
    |> redirect(to: ~p"/comments")
  end
end
