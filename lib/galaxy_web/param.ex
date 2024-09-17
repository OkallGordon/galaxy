defimpl Phoenix.Param, for: Galaxy.Multimedia.Video do
  def to_param(%{slug: slug, id: id}) do
    "#{id}-#{slug}"
  end
end
