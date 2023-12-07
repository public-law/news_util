defmodule News.DateModifiedTest do
  @moduledoc false
  use ExUnit.Case
  doctest News.DateModified

  test "parse/1 returns nil when there's no schema" do
    {:ok, document} = Floki.parse_document("<html></html>")

    assert News.DateModified.parse(document) == nil
  end


  test "parse/1 returns nil when there's no dateModified" do
    {:ok, document} = Floki.parse_document("<html><script type='application/ld+json'>{\"datePublished\": \"2020-01-01\"}</script></html>")

    assert News.DateModified.parse(document) == nil
  end


  test "parse/1 return the Date when there's a dateModified" do
    {:ok, document} = Floki.parse_document("<html><script type='application/ld+json'>{\"dateModified\": \"2020-01-01\"}</script></html>")

    assert News.DateModified.parse(document) == ~D[2020-01-01]
  end
end
