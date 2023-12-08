defmodule News.PublicLaw do
  @moduledoc false

  @spec url_to_cite(URI.t) :: binary
  def url_to_cite(%URI{path: path}) do
    path
    |> String.split("/")
    |> List.last
    |> String.replace("_", " ")
    |> News.Text.titleize
  end
end
