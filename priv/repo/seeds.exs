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
alias Galaxy.Repo
alias Galaxy.Accounts.User

%User{name: "Gordon", email: "gordon@example.com"} |> Repo.insert()
%User{name: "Okoth", email: "okoth@example.com"} |> Repo.insert()
%User{name: "James", email: "james@example.com"} |> Repo.insert()
%User{name: "Okall", email: "okall@example.com"} |> Repo.insert()
