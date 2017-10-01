defmodule Cache do
  use GenServer

  @name CACHE

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: CACHE])
  end

  def write(key, value) do
    GenServer.call(@name, {:write, {key, value}})
  end

  def read(key) do
    GenServer.call(@name, {:read, key})
  end

  def delete(key) do
    GenServer.call(@name, {:delete, key})
  end

  def clear do
    GenServer.cast(@name, :clear)
  end

  def exist?(key) do
    GenServer.call(@name, { :exist?, key })
  end

  def stop do
    GenServer.cast(@name, :stop)
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:write, {key, value}}, _from, state) do
    new_state = update_state(state, {key, value})
    {:reply, "Data written.", new_state}
  end

  def handle_call({:read, key}, _from, state) do
    value = get_value(state, key)
    {:reply, value, state}
  end

  def handle_call({:delete, key}, _from, state) do
    new_state = delete_state(state, key)
    {:reply, "All key values has been deleted.", new_state}
  end

  def handle_call({:exist?, key}, _from, state ) do
    {:reply, Map.has_key?(state, key), state}
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  def handle_cast(:clear, _state) do
    {:noreply, %{}}
  end

  ## Helpers Functions

  def update_state(old_state, {key, value}) do
    case Map.has_key?(old_state, key) do
      true -> Map.update!(old_state, key, value)
      false -> Map.put_new(old_state, key, value)
    end
  end

  def delete_state(old_state, key) do
    Map.delete(old_state, key)
  end

  def get_value(state, key) do
    case Map.has_key?(state, key) do
    true ->
      Map.fetch!(state, key)
    false ->
      %{}
    end
  end


end
