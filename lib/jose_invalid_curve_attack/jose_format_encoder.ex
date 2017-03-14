defmodule JOSEFormatEncoder do

  def decode(binary, opts \\ []) do
    Poison.decode(binary, opts)
  end

  def decode!(binary, opts \\ []) do
    Poison.decode!(binary, opts)
  end

  def encode(term, opts \\ []) do
    {:ok, encode!(term, opts)}
  rescue
    exception in [Poison.EncodeError, JOSE.Poison.LexicalEncodeError] ->
      {:error, {:invalid, exception.value}}
  end

  def encode!(term, opts \\ []) do
    JOSE.Poison.lexical_encode!(term, opts)
  end

  def encode_to_iodata(term, opts \\ []) do
    encode(term, [iodata: true] ++ opts)
  end

  def encode_to_iodata!(term, opts \\ []) do
    encode!(term, [iodata: true] ++ opts)
  end

end
