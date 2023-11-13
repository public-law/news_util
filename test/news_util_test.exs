import NewsUtil

defmodule NewsUtilTest do
  use ExUnit.Case
  doctest NewsUtil

  def fixture(name) do
    Path.join("test/fixtures", name)
  end


  test "California citations when the leginfo links are standard" do
    filename = fixture("qandasec5.asp")
    assert find_citations(file: filename) == ["CA Educ Code Section 47605", "CA Educ Code Section 47605.6"]
  end

  test "California citations when the leginfo links have reversed params" do
    filename = fixture("qandasec6.asp")
    assert find_citations(file: filename) == ["CA Educ Code Section 47605"]
  end

  test "Texas citations when they're in public.law links" do
    filename = fixture("Formal Marriage License | Fort Bend County.html")

    assert find_citations(file: filename) == [
      "Tex. Fam. Code Section 2.003",
      "Tex. Fam. Code Section 2.013",
      "Tex. Fam. Code Section 2.203",
    ]
  end

  test "Colorado CRS citations in a PDF" do
    filename = fixture("JDF432.pdf")

    assert find_citations(file: filename) == [
      "C.R.S. 13-15-101",
      "C.R.S. 13-15-102",
    ]
  end
end
