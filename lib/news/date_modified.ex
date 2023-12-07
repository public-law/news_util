defmodule News.DateModified do
  @moduledoc """
  Parses the most recent Published Date from a news article.
  """


  def parse(document) do
    {:ok, struct} =
      case Floki.find(document, "script[type='application/ld+json']") do
        [] -> {:ok, nil}
        [{_, _, schema_text}] -> Jason.decode(schema_text)
      end

    case struct do
      nil -> nil
      _ ->
        case Map.get(struct, "dateModified") do
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
