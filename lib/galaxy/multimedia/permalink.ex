defmodule Galaxy.Multimedia.Permalink do
  @behaviour Ecto.Type

  # Specifies the custom Ecto type, :id is commonly used for primary keys
  def type, do: :id

  # Cast function to handle binary input and convert it to an integer
  def cast(binary) when is_binary(binary) do
    case Integer.parse(binary) do
      {int, _} when int > 0 -> {:ok, int}
      _ -> :error
    end
  end

  # Casts integer values as is
  def cast(integer) when is_integer(integer) do
    {:ok, integer}
  end

  # Handles invalid cases during casting
  def cast(_), do: :error

  # Dumps integer values into a format suitable for database storage
  def dump(integer) when is_integer(integer) do
    {:ok, integer}
  end

  # Loads integer values from the database
  def load(integer) when is_integer(integer) do
    {:ok, integer}
  end

  # The new required function for embedding behavior
  # Since we are not doing anything special for embedding, we can return :self
  def embed_as(_format), do: :self

  # A function to determine equality between two values of the custom type
  # You can add custom equality checks here; for simple types like integers, use ==
  def equal?(value1, value2), do: value1 == value2
end
