defmodule GraphEx.Graph do
  @moduledoc """
  Simple implementation of _graph_.

  It allows adding _Vertices_ and connecting them with _Edges_.

  _Vertex_ is also known as a _Node_ and _Edge_ is a connection between _Nodes_.

  Graphs can be modified with actions of:

    * Adding the node: `GraphEx.Graph.add_node/2`
    * Adding the edge: `GraphEx.Graph.add_edge/3`
    * Removing the node: `GraphEx.Graph.remove_node/2`
    * Removing the edge: `GraphEx.Graph.remove_edge/3`
    * Searching if graph contains a value: `GraphEx.Graph.contains?/2`
    * Checking if connection exists between two nodes: `GraphEx.Graph.has_edge?/3`
  """

  @doc """
  Adds `node` to the `graph`.

  ## Example:

      iex> graph = %{}
      iex> GraphEx.Graph.add_node(graph, "Node1")
      {:ok, %{"Node1" => %{edges: %{}}}}

  """
  def add_node(graph, node) do
    {:ok, Map.put(graph, node, %{edges: %{}})}
  end

  @doc """
  Checks if `graph` contains specified `node`.

  ## Examples:

      iex> graph = %{"Node1" => %{edges: %{}}}
      iex> GraphEx.Graph.contains?(graph, "Node1")
      true

      iex> graph = %{}
      iex> GraphEx.Graph.contains?(graph, "Node1")
      false

  """
  def contains?(graph, node) do
    Map.has_key?(graph, node)
  end

  @doc """
  Removes `node_to_remove` from `graph` if exists.

  ## Examples:

      iex> graph = %{"Node1" => %{edges: %{}}}
      ...> GraphEx.Graph.remove_node(graph, "Node1")
      {:ok, %{}}

      iex> graph = %{"Node1" => %{edges: %{"Node2" => true}},
      ...>           "Node2" => %{edges: %{"Node1" => true}}}
      ...> GraphEx.Graph.remove_node(graph, "Node1")
      {:ok, %{"Node2" => %{edges: %{}}}}

      iex> graph = %{"Node1" => %{edges: %{}}}
      ...> GraphEx.Graph.remove_node(graph, "Node2")
      :error

  """
  def remove_node(graph, node_to_remove) do
    if contains?(graph, node_to_remove) do
      new_graph =
        graph
        |> Enum.map(fn({node, val}) ->
             {
               node,
               update_in(val, [:edges], &Map.delete(&1, node_to_remove))
             }
           end)
        |> Enum.into(Map.new())
        |> Map.delete(node_to_remove)

      {:ok, new_graph}
    else
      :error
    end
  end

  @doc """
  Adds _edge_ between `start_node` and `end_node` in `graph`.

  ## Examples:

      iex> graph = %{"Node1" => %{edges: %{}},
      ...>           "Node2" => %{edges: %{}}}
      ...> GraphEx.Graph.add_edge(graph, "Node1", "Node2")
      {:ok, %{"Node1" => %{edges: %{"Node2" => true}},
      "Node2" => %{edges: %{"Node1" => true}}}}

      iex> graph = %{"Node1" => %{edges: %{}}}
      ...> GraphEx.Graph.add_edge(graph, "Node1", "Node2")
      :error

  """
  def add_edge(graph, start_node, end_node) do
    if contains?(graph, start_node) && contains?(graph, end_node) do
      new_graph =
        graph
        |> update_in([start_node, :edges], &Map.put(&1, end_node, true))
        |> update_in([end_node, :edges], &Map.put(&1, start_node, true))

      {:ok, new_graph}
    else
      :error
    end
  end

  @doc """
  Checks if there is an `edge` for both _nodes_ in the `graph`.

  ## Examples:

      iex> graph = %{"Node1" => %{edges: %{"Node2" => true}},
      ...>           "Node2" => %{edges: %{"Node1" => true}}}
      ...> GraphEx.Graph.has_edge?(graph, "Node1", "Node2")
      true

      iex> graph = %{"Node1" => %{edges: %{}}}
      ...> GraphEx.Graph.has_edge?(graph, "Node1", "Node2")
      false

  """
  def has_edge?(graph, start_node, end_node) do
    get_in(graph, [start_node, :edges, end_node]) != nil
  end

  @doc """
  Removes `edge` between provided _nodes_ in `graph`.

  ## Examples:

    iex> graph = %{"Node1" => %{edges: %{"Node2" => true}},
    ...>           "Node2" => %{edges: %{"Node1" => true}}}
    ...> GraphEx.Graph.remove_edge(graph, "Node1", "Node2")
    {:ok, %{"Node1" => %{edges: %{}},
            "Node2" => %{edges: %{}}}}

    iex> graph = %{"Node1" => %{edges: %{}},
    ...>           "Node2" => %{edges: %{}}}
    ...> GraphEx.Graph.remove_edge(graph, "Node1", "Node2")
    :error

  """
  def remove_edge(graph, start_node, end_node) do
    if has_edge?(graph, start_node, end_node) do
      new_graph =
        graph
        |> update_in([start_node, :edges], &Map.delete(&1, end_node))
        |> update_in([end_node, :edges], &Map.delete(&1, start_node))

      {:ok, new_graph}
    else
      :error
    end
  end
end
