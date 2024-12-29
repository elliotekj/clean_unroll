defmodule CleanUnroll do
  @moduledoc """
  Unroll and clean URLs by following redirects and removing tracking parameters.

  ## Examples

      iex> CleanUnroll.clean_unroll("https://t.co/shortened-tracked")
      {:ok, "https://example.com/page?custom_param=value"}

      iex> CleanUnroll.clean_unroll("https://t.co/shortened-tracked", ["custom_param"])
      {:ok, "https://example.com/page"}

      iex> CleanUnroll.clean("https://example.com/page?utm_source=twitter&id=123")
      "https://example.com/page?id=123"

      iex> CleanUnroll.unroll("https://t.co/shortened")
      {:ok, "https://example.com/page"}
  """

  @tracking_params ~w(utm_source utm_medium utm_campaign utm_term utm_content fbclid gclid msclkid mc_cid mc_eid ref referrer campaign source cid icid spm)

  @doc """
  Unrolls a URL and removes its tracking parameters.

  ## Parameters

    * `url` - The URL to process
    * `remove_params` - Additional query parameters to remove (optional)
  """
  @spec clean_unroll(binary(), list(binary())) :: {:ok, binary()} | {:error, term()}
  def clean_unroll(url, remove_params \\ []) when is_binary(url) do
    case unroll(url) do
      {:ok, unrolled} -> {:ok, clean(unrolled, remove_params)}
      error -> error
    end
  end

  @doc """
  Unrolls a URL.

  ## Parameters

    * `url` - The URL to unroll
  """
  @spec unroll(binary()) :: {:ok, binary()} | {:error, term()}
  def unroll(url) when is_binary(url) do
    request = Finch.build(:head, url)

    with {:ok, %{status: status, headers: headers}} when status in [301, 302, 303, 307, 308] <-
           Finch.request(request, CleanUnroll.Finch),
         location when not is_nil(location) <- get_location_header(headers) do
      unroll(location)
    else
      {:ok, %{status: status}} when status in 200..299 ->
        {:ok, url}

      {:ok, resp} ->
        {:error, "Response Status #{resp.status}"}

      {:error, reason} ->
        {:error, reason}

      nil ->
        {:error, "No Location header in redirect response"}
    end
  end

  @doc """
  Removes tracking parameters from a URL.

  ## Parameters

    * `url` - The URL to clean
    * `remove_params` - Additional query parameters to remove (optional)
  """
  @spec clean(binary(), list(binary())) :: binary()
  def clean(url, remove_params \\ []) when is_binary(url) do
    params = @tracking_params ++ remove_params
    uri = URI.parse(url)

    case uri.query do
      nil ->
        url

      query ->
        cleaned_query =
          query
          |> URI.decode_query()
          |> Map.drop(params)
          |> URI.encode_query()
          |> then(&if(&1 == "", do: nil, else: &1))

        %{uri | query: cleaned_query}
        |> URI.to_string()
    end
  end

  defp get_location_header(headers) do
    Enum.find_value(headers, fn
      {"location", value} -> value
      {"Location", value} -> value
      _ -> nil
    end)
  end
end
