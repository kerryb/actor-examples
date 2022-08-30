defmodule Counter do
  use GenServer

  def start_link, do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def init(_args), do: {:ok, 0}

  def increment_and_use, do: GenServer.call(__MODULE__, :increment_and_use, :timer.seconds(30))

  def do_something_slow do
    Process.sleep(:rand.uniform(100))
  end

  def get_value, do: GenServer.call(__MODULE__, :get_value)

  def handle_call(:increment_and_use, _from, count) do
    count = do_something_with(count)
    {:reply, count, count}
  end

  def handle_call(:get_value, _from, count) do
    {:reply, count, count}
  end

  defp do_something_with(count) do
    Process.sleep(:rand.uniform(2))
    count + 1
  end
end

{:ok, _pid} = Counter.start_link()

for _ <- 1..100 do
  Task.async(fn ->
    Counter.do_something_slow()
    Counter.increment_and_use()
  end)
end
|> Task.await_many(:timer.seconds(30))

IO.puts(Counter.get_value())
