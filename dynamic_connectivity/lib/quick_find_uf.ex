defmodule QuickFindUF do
  defstruct entries: %{}

  def new(entries_count) do
    entries =
      for x <- 0..entries_count,
        into: Map.new,
        do: {x, x}

    %__MODULE__{entries: entries}
  end

  def connected?(%__MODULE__{entries: entries}, p, q) do
    with {:ok, pid} <- Map.fetch(entries, p),
         {:ok, qid} <- Map.fetch(entries, q) do
      pid == qid
    else
      _ -> false
    end
  end

  def union(%__MODULE__{entries: entries} = str, p, q) do
    pid = entries[p]
    qid = entries[q]

    new_entries =
      entries
      |> Enum.map(fn
           {k, v} when v == pid -> {k, qid}
           entry                -> entry
         end)
      |> Enum.into(Map.new)

    Map.put(str, :entries, new_entries)
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(str, opts) do
      concat ["#QuickFindUF<", to_doc(Map.keys(str.entries), opts), ">"]
    end
  end
end
