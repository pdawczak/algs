defmodule QuickUnionUF do
  defstruct [:elems]

  def new(elems_count) do
    elems = for x <- 0..elems_count, into: Map.new(), do: {x, x}

    %__MODULE__{elems: elems}
  end

  def connected?(str, p, q) do
    with true <- Map.has_key?(str.elems, p),
         true <- Map.has_key?(str.elems, q)
    do
      root(str, p) == root(str, q)
    else
      _ -> false
    end
  end

  def union(str, p, q) do
    root_p = root(str, p)
    root_q = root(str, q)

    new_elems =
      Map.update(str.elems, root_p, root_p, fn _ -> root_q end)

    %__MODULE__{elems: new_elems}
  end

  defp root(str, elem) do
    find_root(str, elem, str.elems[elem])
  end

  defp find_root(_str, elem, elem) do
    elem
  end
  defp find_root(str, _elem, new_elem) do
    find_root(str, new_elem, str.elems[new_elem])
  end
end
