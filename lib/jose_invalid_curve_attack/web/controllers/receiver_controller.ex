defmodule JoseInvalidCurveAttack.Web.ReceiverController do
  use JoseInvalidCurveAttack.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  @public_jwk %{
    "kty" => "EC",
    "kid" => "3f7b122d-e9d2-4ff7-bdeb-a1487063d799",
    "crv" => "P-256",
    "x" => "ufQkXr3L841ATLhZ4rQ4e--udQtLWawOxmjVjg88Y8Q",
    "y" => "mEfxmKOAIqlEo9oAWpI8KUk82G7xh_2BOfTglU5GPss"
  }
  @secret_jwk %{
    "kty" => "EC",
    "kid" => "3f7b122d-e9d2-4ff7-bdeb-a1487063d799",
    "crv" => "P-256",
    "x" => "ufQkXr3L841ATLhZ4rQ4e--udQtLWawOxmjVjg88Y8Q",
    "y" => "mEfxmKOAIqlEo9oAWpI8KUk82G7xh_2BOfTglU5GPss",
    "d" => "AFYY"
  }

  def get_public_key(conn, _params) do
    json conn, @public_jwk
  end

  def post_secret(conn, %{ "token" => token }) do
    secret_jwk = JOSE.JWK.from_map(@secret_jwk)
    try do
      JOSE.JWE.block_decrypt(secret_jwk, token)
      send_resp(conn, 200, "OK")
    rescue
      ArgumentError ->
        send_resp(conn, 400, "Bad request")
    end
    # try do
      
    # end
    # jose.JWK.asKey(v.jwk).then(function (key) {
    #       var jwe = JWE.createDecrypt(key);
    #       return jwe.decrypt(token);
    #     }).then(function () {
    #       res.status(200);
    #       res.send("OK");
    #     }).catch(function (e) {
    #       console.log(e);
    #       res.status(400);
    #       res.send("Bad request");
    #     });
  end
end
