defmodule Before do
  use Maru.Middleware

  def call(conn, _opts) do
    IO.puts "BEFORE"
    conn
  end
end

defmodule MyAPP.Router.Homepage do
  use Maru.Router

  get do
    %{ hello: :world }
  end

  get "/api/v1/tweets" do
    db = Mongo.db(Mongo.connect!, "elixirapi")
    tweets = Mongo.Db.collection(db, "tweets")
      |> Mongo.Collection.find
      |> Enum.to_list
    tweets = Enum.map tweets, fn t ->
      %{ id: to_string(t._id), body: t.body }
    end
    %{ results: tweets }
  end
end

defmodule MyAPP.API do
  use Maru.Router
  plug Before
  mount MyAPP.Router.Homepage

  rescue_from :all, as: e do
    status 500
    IO.inspect e
  end
end
