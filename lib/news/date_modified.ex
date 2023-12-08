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


  defp parse_ld_json(%{"dateModified" => date}) do
    iso_date = Regex.run(~r/(\d{4}-\d{2}-\d{2})/, date) |> List.first
    case Date.from_iso8601(iso_date) do
      {:ok, date} -> date
      _ -> nil
    end
  end

  defp parse_ld_json(_), do: nil
end
