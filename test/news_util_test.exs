import NewsUtil

defmodule NewsUtilTest do
  @moduledoc false
  use ExUnit.Case
  doctest NewsUtil

  def fixture(name) do
    Path.join("test/fixtures", name)
  end

  def find_citations_in_fixture(name) do
    find_citations_in_file(fixture(name))
  end


  test "California citations when the leginfo links are standard" do
    assert find_citations_in_fixture("qandasec5.asp") == ["CA Educ Code Section 47605", "CA Educ Code Section 47605.6"]
  end


  test "California citations when the leginfo links have reversed params" do
    assert find_citations_in_fixture("qandasec6.asp") == ["CA Educ Code Section 47605"]
  end


  test "Texas links to public.law" do
    assert find_citations_in_fixture("Formal Marriage License | Fort Bend County.html") == [
      "Tex. Fam. Code Section 2.003",
      "Tex. Fam. Code Section 2.013",
      "Tex. Fam. Code Section 2.203",
    ]
  end


  test "Texas text cites" do
    filename = fixture("article279569109.html")

    assert find_citations_in_file(filename) == [
      "Tex. Penal Code Section 38.02",
      "Tex. Transp. Code Section 521.025",
    ]
  end


  test "Colorado plain-text CRS citations in a PDF" do
    filename = fixture("JDF432.pdf")

    assert find_citations_in_file(filename) == [
      "C.R.S. 13-15-101",
      "C.R.S. 13-15-102",
    ]
  end


  test "NY links to public.law" do
    filename = fixture("Potential expulsions for SUNY and CUNY students convicted of hate crimes, amidst surge in antisemitic incidents _ WRGB.html")
    assert find_citations_in_file(filename) == [
      "N.Y. Penal Law Section 485.05"
    ]
  end

  test "ORS links to public.law - 1" do
    assert(
      find_citations_in_file(fixture("autopsy-laws-by-state")) ==
      ["ORS 146.117"]
    )
  end

  test "ORS links to public.law - 2" do
    assert(
      find_citations_in_file(fixture("ppb-police-body-came-explained-how-it-works")) ==
      ["ORS 133.741"]
    )
  end

  test "Crashing Cal page" do
    assert(
      find_citations_in_file(fixture("medical-leave.html")) ==
      ["CA Lab Code Section 233"]
    )
  end

  test "Colorado text cites" do
    assert(
      find_citations_in_file(fixture("colorado-knife-laws.html")) ==
        [
          "C.R.S. 18-12-101",
          "C.R.S. 18-12-102",
          "C.R.S. 18-12-105",
          "C.R.S. 18-12-105.5",
        ]
    )
  end
end
