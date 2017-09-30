defmodule Cache do
  use GenServer

  @name CACHE

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: CACHE])
  end

  def write(key, value) do
    GenServer.call(@name, {key, value})
  end

  def read(key) do
    GenServer.call(@name, key)
  end

  def delete(key) do

  end

  def clear do

  end

  def exist? do

  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({key, value}, _from, state) do
    new_state = update_state(state, {key, value})
    {:reply, "Data written.", new_state}
  end

  def handle_call(key, _from, state) do
    {:reply, state, state}
  end

  ## Helpers Functions

  def update_state(old_state, {key, value}) do
    Map.new([ { key, value } ])
  end
end
