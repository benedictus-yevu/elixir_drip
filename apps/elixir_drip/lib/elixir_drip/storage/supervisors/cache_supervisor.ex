defmodule ElixirDrip.Storage.Supervisors.CacheSupervisor do
  def start_link do
    DynamicSupervisor.start_link(name: __MODULE__, strategy: :one_for_one)
  end

  def server_process(media_id,content) do
    existing_process(media_id) || start_child({media_id,content})
  end


  def existing_process(media_id) do
    ElixirDrip.Storage.Workers.CacheWorker.explicit_lookup(media_id)
  end


  def start_child({media_id,content}) do
    case DynamicSupervisor.start_child(__MODULE__,{ElixirDrip.Storage.Workers.CacheWorker,{media_id,content}}) do
      {:ok,pid} -> pid
      {:error,{:already_started, pid}} -> pid
    end
  end

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__,:start_link,[]},
      type: :supervisor,
      restart: :transient
    }
  end
end
