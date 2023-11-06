defmodule NewsUtilTest do
  use ExUnit.Case
  doctest NewsUtil

  def fixture(name) do
    File.read!("test/fixtures/#{name}")
  end


  test "finds California citations when the leginfo links are standard" do
    html = fixture("qandasec5.asp")
    assert NewsUtil.find_citations(html) == ["CA Educ Code Section 47605", "CA Educ Code Section 47605.6"]
  end

  test "finds California citations when the leginfo links have reversed params" do
    html = fixture("qandasec6.asp")
    assert NewsUtil.find_citations(html) == ["CA Educ Code Section 47605"]
  end
end
