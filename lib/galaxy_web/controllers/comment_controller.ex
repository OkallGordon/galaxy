defmodule GalaxyWeb.CommentController do
  use GalaxyWeb, :controller

  alias Galaxy.Comments
  alias Galaxy.Comments.Comment

  def index(conn, _params) do
    current_user = get_current_user(conn)
    comments = Comments.list_user_comments(current_user)
    render(conn, "index.html", comments: comments)
  end

  defp get_current_user(conn) do
    conn.assigns[:current_user]
  end

  def new(conn, _params) do
    changeset = Comments.change_comment(%Comment{})
    users = Galaxy.Accounts.list_users()
    render(conn, "new.html", changeset: changeset, users: users)
  end

  def create(conn, %{"comment" => comment_params}) do
    current_user = get_current_user(conn)
    case Comments.create_user_comment(current_user, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Your comment has been created successfully.")
        |> redirect(to: ~p"/comments/#{comment.id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        users = Galaxy.Accounts.list_users()
        render(conn, "new.html", changeset: changeset, users: users)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = get_current_user(conn)
    comment = Comments.get_user_comment!(current_user, id)
    render(conn, "show.html", comment: comment)
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
