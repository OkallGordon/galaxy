# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Galaxy.Repo.insert!(%Galaxy.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Galaxy.Multimedia

categories = [
  "Action",
  "Drama",
  "Romance",
  "Comedy",
  "Sci-fi",
  "Horror",
  "History",
  "Reality",
  "News"
]

for category_name <- categories do
  Multimedia.create_category!(category_name)
end
