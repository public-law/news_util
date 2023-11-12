defmodule NewsUtilTest do
  use ExUnit.Case
  doctest NewsUtil

  def fixture(name) do
    Path.join("test/fixtures", name)
  end


  test "finds California citations when the leginfo links are standard" do
    filename = fixture("qandasec5.asp")
    assert NewsUtil.find_citations(file: filename) == ["CA Educ Code Section 47605", "CA Educ Code Section 47605.6"]
  end

  test "finds California citations when the leginfo links have reversed params" do
    filename = fixture("qandasec6.asp")
    assert NewsUtil.find_citations(file: filename) == ["CA Educ Code Section 47605"]
  end

  test "finds Texas citations when they're in public.law links" do
    filename = fixture("Formal Marriage License | Fort Bend County.html")

    assert NewsUtil.find_citations(file: filename) == [
      "Tex. Fam. Code Section 2.003",
      "Tex. Fam. Code Section 2.013",
      "Tex. Fam. Code Section 2.203",
    ]
  end
end
