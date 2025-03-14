defmodule SuperWorkerExample.ExampleRuntime do
  @doc false

  alias SuperWorker.Supervisor, as: Sup

  # Start the supervisor, add a group and a chain.
  def start(sup_id \\ :sup1) do
    result = Sup.start([link: false, id: sup_id])
    IO.inspect result

    # Group & workers for group.
    # add_group_data()

    # Standalone
    #add_standalone_data()

    # Chain & its workers.
    # add_chain_data(sup_id)
  end

  def add_group_data(sup_id \\ :sup1, group \\ :group_1, restart_strategy \\ :one_for_all, num_workers \\ 3) do
    {:ok, _} = Sup.add_group(sup_id, [id: group, restart_strategy: restart_strategy])
    for i <- 1..num_workers do
      {:ok, _} = Sup.add_group_worker(sup_id, group, {__MODULE__, :task, [15]}, [id: :"w_#{i}"])
    end
  end

  def add_group_data_loop(sup_id \\ :sup1, group \\ :group_loop, restart_strategy \\ :one_for_all, num_workers \\ 3) do
    {:ok, _} = Sup.add_group(sup_id, [id: group, restart_strategy: restart_strategy])
    for i <- 1..num_workers do
      {:ok, _} = Sup.add_group_worker(sup_id, :group_loop, {__MODULE__, :loop, [i]}, [id: :"w_#{i}"])
    end
  end

  def add_chain_data(sup_id \\ :sup1, chain_id \\ :chain_1, restart_strategy \\ :one_for_one, num_workers \\ 3, process_of_worker \\ 3) do
    {:ok, _} = Sup.add_chain(sup_id, [id: chain_id, restart_strategy: restart_strategy, finished_callback: {__MODULE__, :print,[chain_id]}, send_type: :partition])
    for i <- 1..num_workers do
      {:ok, _} = Sup.add_chain_worker(sup_id, chain_id, {__MODULE__, :task, [15]}, [id: :"c_#{i}", num_workers: process_of_worker])
    end
  end

  def add_standalone_data(sup_id \\ :sup1) do
    {:ok, _} = Sup.add_standalone_worker(sup_id, {__MODULE__, :task, [15]}, [id: :w1, restart_strategy: :permanent])
    {:ok, _} = Sup.add_standalone_worker(sup_id, {__MODULE__, :task_crash, [15, 5]}, [id: :w2, restart_strategy: :transient])
    {:ok, _} = Sup.add_standalone_worker(sup_id, fn ->
      receive do
        msg -> IO.puts "Standalone worker received: #{inspect msg}"
      end
    end, [id: :w3, restart_strategy: :temporary])
  end
end
