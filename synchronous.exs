defmodule Counter do
  use GenServer

  def start_link, do: GenServer.start_link(__MODULE__, [])

  def init(_args), do: {:ok, 0}

  def handle_call(:increment_and_use, _from, count) do
    do_something_slow()
    count = do_something_with(count)
    {:reply, count, count}
  end

  def handle_call(:get_value, _from, count) do
    {:reply, count, count}
  end

  defp do_something_slow do
    Process.sleep(:rand.uniform(100))
  end

  defp do_something_with(count) do
    Process.sleep(:rand.uniform(2))
    count + 1
  end
end

{:ok, pid} = Counter.start_link()

for _ <- 1..100 do
  GenServer.call(pid, :increment_and_use)
end

IO.puts(GenServer.call(pid, :get_value))
