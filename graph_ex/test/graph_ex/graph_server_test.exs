defmodule GraphEx.GraphServerTest do
  use ExUnit.Case, async: true
  alias GraphEx.GraphServer

  doctest GraphEx.GraphServer

  setup do
    {:ok, pid} = GraphServer.start_link()

    {:ok, server: pid}
  end

  test "manipulates nodes", %{server: server} do
    refute GraphServer.contains?(server, "Linus Torvalds")

    GraphServer.add_node(server, "Linus Torvalds")
    assert GraphServer.contains?(server, "Linus Torvalds")

    GraphServer.remove_node(server, "Linus Torvalds")
    refute GraphServer.contains?(server, "Linus Torvalds")
  end

  test "manipulates connections between nodes", %{server: server} do
    GraphServer.add_node(server, "Linus Torvalds")
    GraphServer.add_node(server, "James Gosling")
    GraphServer.add_node(server, "Guido Rossum")

    GraphServer.add_edge(server, "Linus Torvalds", "James Gosling")

    assert GraphServer.has_edge?(server, "Linus Torvalds", "James Gosling")
    refute GraphServer.has_edge?(server, "Linus Torvalds", "Guido Rossum")

    GraphServer.remove_edge(server, "Linus Torvalds", "James Gosling")

    refute GraphServer.has_edge?(server, "Linus Torvalds", "James Gosling")
  end
end
