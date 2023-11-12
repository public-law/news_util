defmodule NewsUtilTest do
  use ExUnit.Case
  doctest NewsUtil

  def fixture_path(name) do
    Path.join("test/fixtures", name)
  end

  def fixture(name) do
    File.read!(fixture_path(name))
  end


  test "finds California citations when the leginfo links are standard" do
    html = fixture("qandasec5.asp")
    assert NewsUtil.find_citations(html) == ["CA Educ Code Section 47605", "CA Educ Code Section 47605.6"]
  end

  test "gets cites from a file directly" do
    assert NewsUtil.find_citations(file_path: fixture_path("qandasec5.asp")) == ["CA Educ Code Section 47605", "CA Educ Code Section 47605.6"]
  end

  test "finds California citations when the leginfo links have reversed params" do
    html = fixture("qandasec6.asp")
    assert NewsUtil.find_citations(html) == ["CA Educ Code Section 47605"]
  end

  test "finds Texas citations when they're in public.law links" do
    html = fixture("Formal Marriage License | Fort Bend County.html")
    assert NewsUtil.find_citations(html) == [
      "Tex. Fam. Code Section 2.003",
      "Tex. Fam. Code Section 2.013",
      "Tex. Fam. Code Section 2.203",
    ]
  end
end
