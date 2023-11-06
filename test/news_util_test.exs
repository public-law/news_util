defmodule NewsUtilTest do
  use ExUnit.Case
  doctest NewsUtil

  test "greets the world" do
    assert NewsUtil.hello() == :world
  end

  test "finds California citations when the leginfo links are standard" do
    html = fixture("qandasec5.asp")
    assert NewsUtil.find_citations(html) == ["CA Educ Code Section 47605", "CA Educ Code Section 47605.6"]
  end
end
