defmodule Galaxy.GeminiClient do
  @moduledoc """
  A client for interacting with the Gemini AI service.
  """

  @api_url "https://api.gemini.ai/summarize"
  @api_key "AIzaSyBc8D-YqAGkYJ0GJ9NabGOok5eQ5uNAtAE" # Your API key

  def summarize_comments(comments) when is_list(comments) do
    payload = %{comments: comments}

    # Make a POST request to the Gemini API
    case HTTPoison.post(@api_url, Jason.encode!(payload), [{"Authorization", "Bearer #{@api_key}"}, {"Content-Type", "application/json"}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)["summary"]}  # Assuming the API returns a field "summary"

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
