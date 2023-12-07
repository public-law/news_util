defmodule News.DateModified do
  @moduledoc """
  Parses the most recent Published Date from a news article.
  """


  def parse(document) do
    schema =
      document
      |> Floki.find("script[type='application/ld+json']")
      |> dbg

    case schema do
      [] -> nil
      _ ->
        case Jason.decode(Floki.text(schema)) do
          {:ok, json} ->
            case Map.get(json, "dateModified") do
              nil -> nil
              date_modified ->
                case Date.from_iso8601(date_modified) do
                  {:ok, date} -> date
                  _ -> nil
                end
            end
        end
    end
  end
end
