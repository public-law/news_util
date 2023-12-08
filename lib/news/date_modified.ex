defmodule News.DateModified do
  @moduledoc """
  Parses the most recent Published Date from a news article.
  """

  @spec parse(Floki.html_tree) :: Date.t | nil
  def parse(document) do
    with [{_, _, schema_text}] <- Floki.find(document, "script[type='application/ld+json']"),
         {:ok, struct}         <- Jason.decode(schema_text) do
      parse_ld_json(struct)
    else
      _ -> nil
    end
  end

  
  defp parse_ld_json(struct) do
    case struct do
      nil -> nil
      _ ->
        case Map.get(struct, "dateModified") do
          nil -> nil
          date_modified ->
            iso_date = Regex.run(~r/(\d{4}-\d{2}-\d{2})/, date_modified) |> List.first
            case Date.from_iso8601(iso_date) do
              {:ok, date} -> date
              _ -> nil
            end
        end
    end
  end
end
