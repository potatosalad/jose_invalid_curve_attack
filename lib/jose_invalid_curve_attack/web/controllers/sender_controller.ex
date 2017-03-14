defmodule JoseInvalidCurveAttack.Web.SenderController do
  use JoseInvalidCurveAttack.Web, :controller

  plug :put_layout, "sender.html"

  def index(conn, _params) do
    render conn, "index.html"
  end

  def post_recover(conn, %{ "url" => url }) do
    try do
      InvalidCurveAttack.Sender.run(url)
    catch
      error, reason ->
        {error, reason}
    end
    |> case do
      {:ok, results} ->
        # require IEx
        # IEx.pry
        render conn, "recover.html", [ results: results ]
    end
  end
end
