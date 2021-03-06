defmodule ElixirDrip.Storage.Workers.CacheWorker do
  use GenServer, restart: :temporary

  @expire_time 60_000

  def start_link({media_id, content}) do
    GenServer.start_link(__MODULE__, content, name: name_for(media_id))
  end

  def name_for(media_id), do: {:global, {:cache, media_id}}

  #explicit lookpu first
  def explicit_lookup(media_id) do
    case :global.whereis_name({:cache, media_id}) do
      :undefined -> nil
      pid -> pid
    end
  end

  def init(content) do
    timer = Process.send_after(self(), :expire, @expire_time)
    {:ok, %{hits: 0, content: content, timer: timer}}
  end



  def handle_info(:expire, %{hits: hits} = state) do
    IO.puts "#{inspect(self())}: Terminating cache,
    served #{hits} hits"
    {:stop, :normal, state}
  end

  def handle_info(msg, state), do: super(msg, state)

  def get_media(pid), do: GenServer.call(pid, :get_media)

  def handle_call(:get_media, _from, %{hits: hits, content:
  content, timer: timer} = state) do
    {:reply, {:ok, content}, %{state | hits: hits + 1, timer:
    refresh_timer(timer)}}
  end

  def handle_cast(:refresh, %{timer: timer} = state) do
   {:noreply, %{state | timer: refresh_timer(timer)}}
  end

  defp refresh_timer(timer) do
    Process.cancel_timer(timer)
    Process.send_after(self(), :expire, @expire_time)
  end
end
