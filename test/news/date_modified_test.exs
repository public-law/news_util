alias News.Test



defmodule News.DateModifiedTest do
  @moduledoc false
  use ExUnit.Case
  doctest News.DateModified


  @yoast_schema_org """
  {
    "@context": "https://schema.org",
    "@graph": [
        {
            "@type": "Organization",
            "@id": "https://probatestars.com/#organization",
            "name": "Probate Stars",
            "url": "https://probatestars.com/",
            "sameAs": [
                "https://www.facebook.com/Probate-Stars-104203374358153/"
            ],
            "logo": {
                "@type": "ImageObject",
                "@id": "https://probatestars.com/#logo",
                "inLanguage": "en-US",
                "url": "https://probatestars.com/wp-content/uploads/2020/03/profil-facebook.jpg",
                "width": 180,
                "height": 180,
                "caption": "Probate Stars"
            },
            "image": {
                "@id": "https://probatestars.com/#logo"
            }
        },
        {
            "@type": "WebSite",
            "@id": "https://probatestars.com/#website",
            "url": "https://probatestars.com/",
            "name": "Probate Stars",
            "description": "Find a Probate Lawyer in all 50 States",
            "publisher": {
                "@id": "https://probatestars.com/#organization"
            },
            "potentialAction": [
                {
                    "@type": "SearchAction",
                    "target": "https://probatestars.com/?s={search_term_string}",
                    "query-input": "required name=search_term_string"
                }
            ],
            "inLanguage": "en-US"
        },
        {
            "@type": "ImageObject",
            "@id": "https://probatestars.com/texas-trust-protector-has-no-fiduciary-duty-to-settlor/#primaryimage",
            "inLanguage": "en-US",
            "url": "https://probatestars.com/wp-content/uploads/2019/12/texas-15.jpg",
            "width": 1999,
            "height": 1333,
            "caption": "Texas trust protector fiduciary"
        },
        {
            "@type": "WebPage",
            "@id": "https://probatestars.com/texas-trust-protector-has-no-fiduciary-duty-to-settlor/#webpage",
            "url": "https://probatestars.com/texas-trust-protector-has-no-fiduciary-duty-to-settlor/",
            "name": "Texas Trust Protector Has No Fiduciary Duty to Settlor | Probate Stars",
            "isPartOf": {
                "@id": "https://probatestars.com/#website"
            },
            "primaryImageOfPage": {
                "@id": "https://probatestars.com/texas-trust-protector-has-no-fiduciary-duty-to-settlor/#primaryimage"
            },
            "datePublished": "2020-05-19T16:20:34+00:00",
            "dateModified": "2020-05-19T16:20:34+00:00",
            "description": "Under Texas law a trust protector has no fiduciary duty to the settlor of the trust, but may have one to the trustee or beneficiaires.",
            "inLanguage": "en-US",
            "potentialAction": [
                {
                    "@type": "ReadAction",
                    "target": [
                        "https://probatestars.com/texas-trust-protector-has-no-fiduciary-duty-to-settlor/"
                    ]
                }
            ]
        },
        {
            "@type": "Article",
            "@id": "https://probatestars.com/texas-trust-protector-has-no-fiduciary-duty-to-settlor/#article",
            "isPartOf": {
                "@id": "https://probatestars.com/texas-trust-protector-has-no-fiduciary-duty-to-settlor/#webpage"
            },
            "author": {
                "@id": "https://probatestars.com/#/schema/person/0d4a38ec0c5ba42eb7b63278e6501199"
            },
            "headline": "Texas Trust Protector Has No Fiduciary Duty to Settlor",
            "datePublished": "2020-05-19T16:20:34+00:00",
            "dateModified": "2020-05-19T16:20:34+00:00",
            "mainEntityOfPage": {
                "@id": "https://probatestars.com/texas-trust-protector-has-no-fiduciary-duty-to-settlor/#webpage"
            },
            "publisher": {
                "@id": "https://probatestars.com/#organization"
            },
            "image": {
                "@id": "https://probatestars.com/texas-trust-protector-has-no-fiduciary-duty-to-settlor/#primaryimage"
            },
            "keywords": "Trust Litigation",
            "articleSection": "Texas",
            "inLanguage": "en-US"
        },
        {
            "@type": "Person",
            "@id": "https://probatestars.com/#/schema/person/0d4a38ec0c5ba42eb7b63278e6501199",
            "name": "Jeffrey Skatoff",
            "image": {
                "@type": "ImageObject",
                "@id": "https://probatestars.com/#personlogo",
                "inLanguage": "en-US",
                "url": "https://secure.gravatar.com/avatar/a12f92f4f11563eb702b172299c7aa93?s=96&d=mm&r=g",
                "caption": "Jeffrey Skatoff"
            },
            "description": "Jeffrey Skatoff has been an attorney for over 30 years, practicing in the areas of estate planning, probate, estate litigation, and guardianship litigation.",
            "sameAs": [
                "https://www.facebook.com/jeffrey.skatoff"
            ]
        }
    ]
}
"""

test "parse/1 returns the date from a Yoast-style schema.org" do
  {:ok, document} = Floki.parse_document("<html><script type='application/ld+json'>#{@yoast_schema_org}</script></html>")

  assert News.DateModified.parse(document) == ~D[2020-05-19]
end



  # Refactor the tests into @test-cases for the following tests
  @test_cases [
    %{
      html: "<html></html>",
      date: nil,
    },
    %{
      html: "<html><script type='application/ld+json'>{\"dateBorn\": \"2020-01-01\"}</script></html>",
      date: nil,
    }
  ]

  Enum.each(@test_cases, fn %{html: html, date: date} ->
    test "finds the date in #{html}" do
      {:ok, document} = unquote(html) |> Floki.parse_document

      assert News.DateModified.parse(document) == unquote(date)
    end
  end)



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


  test "article:published_time date source" do
    # <meta property=\"article:published_time\" content=\"2020-05-19T16:20:34+00:00\">
    {:ok, document} = Floki.parse_document("<html><head><meta property=\"article:published_time\" content=\"2020-05-19T16:20:34+00:00\"></head></html>")

    assert News.DateModified.parse(document) == ~D[2020-05-19]
  end


  test "article:published_time date source from HTML" do
    {:ok, document} = "duty-to-settlor.html" |> Test.fixture |> File.read! |> Floki.parse_document

    assert News.DateModified.parse(document) == ~D[2020-05-19]
  end


end
