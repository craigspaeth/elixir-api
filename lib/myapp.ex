defmodule MyAPP.Router.Homepage do
  use Maru.Router

  get do
    %{ hello: :world }
  end
end

defmodule MyAPP.API do
  use Maru.Router

  mount MyAPP.Router.Homepage

  rescue_from :all do
    status 500
    "Server Error"
  end
end