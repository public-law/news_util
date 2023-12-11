alias News.Test

alias News.Article

defmodule News.ArticleTest do
  @moduledoc false
  use ExUnit.Case
  doctest News.Article

  @test_cases [
    %{
      file: "qandasec5.asp",
      cites: ["CA Educ Code Section 47605", "CA Educ Code Section 47605.6"]
    },
    %{
      file: "qandasec6.asp",
      cites: ["CA Educ Code Section 47605"]
    },
    %{
      file: "Formal Marriage License | Fort Bend County.html",
      cites: [
        "Tex. Fam. Code Section 2.003",
        "Tex. Fam. Code Section 2.013",
        "Tex. Fam. Code Section 2.203"
      ]
    },
    %{
      file: "article279569109.html",
      cites: [
        "Tex. Penal Code Section 38.02",
        "Tex. Transp. Code Section 521.025"
      ]
    },
    # %{
    #   file: "JDF432.pdf",
    #   cites: [
    #     "C.R.S. 13-15-101",
    #     "C.R.S. 13-15-102"
    #   ]
    # },
    %{
      file: "Potential expulsions for SUNY and CUNY students convicted of hate crimes, amidst surge in antisemitic incidents _ WRGB.html",
      cites: ["N.Y. Penal Law Section 485.05"]
    },
    %{
      file: "autopsy-laws-by-state",
      cites: ["ORS 146.117"]
    },
    %{
      file: "ppb-police-body-came-explained-how-it-works",
      cites: ["ORS 133.741"]
    },
    %{
      file: "medical-leave.html",
      cites: ["CA Lab Code Section 233"]
    },
    %{
      file: "colorado-knife-laws.html",
      cites: [
        "C.R.S. 18-12-101",
        "C.R.S. 18-12-102",
        "C.R.S. 18-12-105",
        "C.R.S. 18-12-105.5",
      ]
    }
  ]


  Enum.each(@test_cases, fn %{file: f, cites: c} ->
    test "finds the cites in #{f}" do
      path  = unquote(f)
      cites = unquote(c)
      {:ok, document} = path |> Test.fixture_file! |> Floki.parse_document

      assert Article.find_citations_in_html(document) == cites
    end
  end)
end
