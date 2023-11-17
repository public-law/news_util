import NewsUtil

defmodule NewsUtilTest do
  @moduledoc false
  use ExUnit.Case
  doctest NewsUtil

  def fixture(name) do
    Path.join("test/fixtures", name)
  end


  test "California citations when the leginfo links are standard" do
    filename = fixture("qandasec5.asp")
    assert find_citations_in_file(filename) == ["CA Educ Code Section 47605", "CA Educ Code Section 47605.6"]
  end


  test "California citations when the leginfo links have reversed params" do
    filename = fixture("qandasec6.asp")
    assert find_citations_in_file(filename) == ["CA Educ Code Section 47605"]
  end


  test "Texas links to public.law" do
    filename = fixture("Formal Marriage License | Fort Bend County.html")

    assert find_citations_in_file(filename) == [
      "Tex. Fam. Code Section 2.003",
      "Tex. Fam. Code Section 2.013",
      "Tex. Fam. Code Section 2.203",
    ]
  end


  test "Texas text cites" do
    filename = fixture("ar-AA1h19am")

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
end
