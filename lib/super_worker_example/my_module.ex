
defmodule SuperWorkerExample.MyModule do
  @doc false

  alias SuperWorker.Supervisor, as: Sup

  # function to add a worker to the supervisor.
  def task(n, sleep \\ 1_000) do
    prefix = "[#{inspect Process.get({:supervisor, :worker_id})}, #{inspect self()}]"
    IO.puts prefix <> " Task is started, param: #{n}"

    sum = Enum.reduce(1..n, 0, fn i, acc ->
      :timer.sleep(sleep)
      acc + i
    end)
    IO.puts  IO.puts prefix <> " Task done, #{sum}"

    {:next, n + 1}
  end

  def task_crash(n, at, sleep \\ 1_000) do
    prefix = "[#{inspect Process.get({:supervisor, :worker_id})}, #{inspect self()}]"
    IO.puts prefix <> " Task is started, param: #{n}"

    sum = Enum.reduce(1..n, 0, fn i, acc ->
      if i == at, do: raise "Task #{inspect Process.get({:supervisor, :worker_id})} raised an error at #{i}"
      :timer.sleep(sleep)
      acc + i
    end)
    IO.puts prefix <> " Task done, #{sum}"

    {:next, n + 1}
  end

  def send_to_chain(sup_id \\ :sup_1, chain_id \\ :chain_1, data \\ 10) do
    Sup.send_to_chain(sup_id, chain_id, data)
  end

  # return a anonymous function.
  def anonymous do
    fn ->
      prefix = "[#{inspect Process.get({:supervisor, :worker_id})}, #{inspect self()}]"
      IO.puts prefix <> " Anonymous function"
      for i <- 1..5 do
        IO.puts prefix <> " Task #{i}"
        :timer.sleep(1500)
      end
    end
  end

  # receive the result and print it. Raise an error if the result is an error.
  def print({:raise, reason}, chain_id) do
    prefix = "[#{inspect Process.get({:supervisor, :worker_id})}, #{inspect self()}]"
    IO.puts prefix <> " Chain #{inspect chain_id} will raise an error #{inspect reason}"
    raise reason
  end
  def print(result, chain_id) do
    prefix = "[#{inspect Process.get({:supervisor, :worker_id})}, #{inspect self()}]"
    IO.puts prefix <> " Chain #{inspect chain_id} finished with result #{inspect result}"
  end

  # Basic loop, receive messages and print them.
  def loop(id) do
    prefix = "[#{inspect Process.get({:supervisor, :worker_id})}, #{inspect self()}]"
    receive do
      msg -> IO.puts prefix <> " task received: #{inspect msg}"
    end

    loop(id)
  end

  def ping_pong(id) do
    prefix = "[#{inspect Process.get({:supervisor, :worker_id})}, #{inspect self()}, #{inspect id}]"
    receive do
      {:ping, sender} ->
        IO.puts prefix <> ", send :pong to #{inspect sender}"
        send(sender, {:pong, self()})

      msg -> IO.puts prefix <> " task received: #{inspect msg}"
    end
  end
end
