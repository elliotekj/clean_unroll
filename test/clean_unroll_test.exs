defmodule CleanUnrollTest do
  use ExUnit.Case

  describe "clean/2" do
    test "removes UTM parameters" do
      url = "https://elliotekj.com/?utm_source=test&utm_medium=elixir&utm_campaign=dev&keep=true"
      assert CleanUnroll.clean(url) == "https://elliotekj.com/?keep=true"
    end

    test "removes other tracking parameters" do
      url = "https://elliotekj.com?fbclid=123&gclid=456&keep=true"
      assert CleanUnroll.clean(url) == "https://elliotekj.com?keep=true"
    end

    test "removes default and custom parameters" do
      url = "https://elliotekj.com?fbclid=123&gclid=456&keep=true"
      assert CleanUnroll.clean(url, ["keep"]) == "https://elliotekj.com"
    end

    test "handles URLs without query parameters" do
      url = "https://elliotekj.com"
      assert CleanUnroll.clean(url) == url
    end

    test "handles nested URLs" do
      url = "https://elliotekj.com/posts/how-to-write-custom-validations-for-ecto-changesets"
      assert CleanUnroll.clean(url) == url
    end

    test "removes query section if all params are tracking" do
      url = "https://elliotekj.com/?utm_source=twitter&fbclid=123"
      assert CleanUnroll.clean(url) == "https://elliotekj.com/"
    end
  end

  describe "unroll/1" do
    test "follows redirects" do
      {:ok, final_url} = CleanUnroll.unroll("https://dub.sh/0RLmqu5")
      assert final_url =~ "https://elliotekj.com"
    end

    test "handles non-redirect URLs" do
      {:ok, url} = CleanUnroll.unroll("https://elliotekj.com")
      assert url == "https://elliotekj.com"
    end

    test "handles protected URLs" do
      {:ok, url} = CleanUnroll.unroll("https://dub.sh/sZPL2u8")
      assert url == "https://www.scrapingcourse.com/antibot-challenge"
    end

    test "handles nested URLs" do
      {:ok, url} = CleanUnroll.unroll("https://dub.sh/bEuZ4rL")

      assert url ==
               "https://elliotekj.com/posts/how-to-write-custom-validations-for-ecto-changesets"
    end

    test "returns an error for bad URLs" do
      {:error, error} = CleanUnroll.unroll("https://elliotekj.com/unknown")
      assert error == "Response Status 404"
    end
  end

  describe "clean_unroll/1" do
    test "unrolls and cleans URL" do
      {:ok, cleaned} = CleanUnroll.clean_unroll("https://dub.sh/0RLmqu5")
      assert cleaned == "https://elliotekj.com/"
    end
  end
end
