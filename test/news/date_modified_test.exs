defmodule News.DateModifiedTest do
  @moduledoc false
  use ExUnit.Case
  doctest News.DateModified

  test "parse/1 returns nil when there's no schema" do
    {:ok, document} = Floki.parse_document("<html></html>")

    assert News.DateModified.parse(document) == nil
  end


  test "parse/1 returns nil when neither date attribute is present" do
    {:ok, document} = Floki.parse_document("<html><script type='application/ld+json'>{\"dateBorn\": \"2020-01-01\"}</script></html>")

    assert News.DateModified.parse(document) == nil
  end


  test "parse/1 returns the date when there's just a datePublished" do
    {:ok, document} = Floki.parse_document("<html><script type='application/ld+json'>{\"datePublished\": \"2020-01-01\"}</script></html>")

    assert News.DateModified.parse(document) == ~D[2020-01-01]
  end


  test "parse/1 prefers dateModified over datePublished" do
    {:ok, document} = Floki.parse_document("<html><script type='application/ld+json'>{\"datePublished\": \"2020-01-01\", \"dateModified\": \"2020-01-02\"}</script></html>")

    assert News.DateModified.parse(document) == ~D[2020-01-02]
  end


  test "parse/1 returns the Date when there's a dateModified" do
    {:ok, document} = Floki.parse_document("<html><script type='application/ld+json'>{\"dateModified\": \"2020-01-01\"}</script></html>")

    assert News.DateModified.parse(document) == ~D[2020-01-01]
  end


  test "parse/1 returns the Date when there's a dateModified in National Law Review format" do
    {:ok, document} = Floki.parse_document("<html><script type='application/ld+json'>{\"dateModified\": \"Fri, 2023-08-25 21:16:28\"}</script></html>")

    assert News.DateModified.parse(document) == ~D[2023-08-25]
  end


  test "parse/1 returns the Date when there's a dateModified in Ft. Worth Star Telegram format" do
    {:ok, document} = Floki.parse_document("<html><script type='application/ld+json'>{\"dateModified\": \"2023-09-20T16:20:21-05:00\"}</script></html>")

    assert News.DateModified.parse(document) == ~D[2023-09-20]
  end
end
