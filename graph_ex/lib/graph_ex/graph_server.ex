defmodule GraphEx.GraphServer do
  @moduledoc """
  Simple server managing single _graph_.
  """
  use GenServer

  alias GraphEx.Graph

  ###
  # Public API

  @doc """
  Starts new graph server.
  """
  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end

  @doc """
  Adds `node` to `graph`.
  """
  def add_node(graph, node) do
    GenServer.call(graph, {:add_node, node})
  end

  @doc """
  Removes `node` from `graph`.
  """
  def remove_node(graph, node) do
    GenServer.call(graph, {:remove_node, node})
  end

  @doc """
  Checks if `graph` contains `node`.
  """
  def contains?(graph, node) do
    GenServer.call(graph, {:contains, node})
  end

  @doc """
  Adds _edge_ connectin both _nodes_ in `graph`.
  """
  def add_edge(graph, start_node, end_node) do
    GenServer.call(graph, {:add_edge, start_node, end_node})
  end

  @doc """
  Checks if there is an _edge_ connecting both _nodes_ in `graph`.
  """
  def has_edge?(graph, start_node, end_node) do
    GenServer.call(graph, {:has_edge, start_node, end_node})
  end

  @doc """
  Removes _edge_ connecting two _nodes_ in `graph`.
  """
  def remove_edge(graph, start_node, end_node) do
    GenServer.call(graph, {:remove_edge, start_node, end_node})
  end

  ###
  # Callbacks

  @doc false
  def init(:ok) do
    {:ok, Map.new()}
  end

  @doc false
  def handle_call({:add_node, node}, _from, state) do
    {:ok, new_state} = Graph.add_node(state, node)

    {:reply, new_state, new_state}
  end

  @doc false
  def handle_call({:remove_node, node_to_remove}, _from, state) do
    {:ok, new_state} = Graph.remove_node(state, node_to_remove)

    {:reply, new_state, new_state}
  end

  @doc false
  def handle_call({:contains, node}, _from, state) do
    {:reply, Graph.contains?(state, node), state}
  end

  @doc false
  def handle_call({:add_edge, start_node, end_node}, _from, state) do
    case Graph.add_edge(state, start_node, end_node) do
      {:ok, new_state} ->
        {:reply, new_state, new_state}

      :error ->
        {:reply, :error, state}
    end
  end

  @doc false
  def handle_call({:has_edge, start_node, end_node}, _from, state) do
    {:reply, Graph.has_edge?(state, start_node, end_node), state}
  end

  @doc false
  def handle_call({:remove_edge, start_node, end_node}, _from, state) do
    case Graph.remove_edge(state, start_node, end_node) do
      {:ok, new_state} ->
        {:reply, new_state, new_state}

      :error ->
        {:reply, :error, state}
    end
  end
end
