defmodule LearnHttpoison do
  @moduledoc """
  Learning HTTPoison with JSON and HTML parsing
  """

  defmodule JsonClient do
    def fetch_todos do
      "https://jsonplaceholder.typicode.com/todos/1"
      |> HTTPoison.get!()
      |> Map.get(:body)
      |> Jason.decode!()
    end
  end

  defmodule HtmlClient do
    def fetch_elixir_news do
      "https://elixir-lang.org"
      |> HTTPoison.get!()
      |> Map.get(:body)
      |> Floki.parse_document!()
      |> Floki.find("h5")
      |> Floki.text()
    end
  end

  def run do
    # Fetch and parse JSON
    todo = JsonClient.fetch_todos()
    IO.puts("\n=== Todo from JSON API ===")
    IO.inspect(todo) # Will print something like: %{"completed" => false, "id" => 1, "title" => "delectus aut autem", "userId" => 1}

    # Fetch and parse HTML
    news = HtmlClient.fetch_elixir_news()
    IO.puts("\n=== Latest Elixir News Titles ===")
    IO.puts(news)
  end
end
