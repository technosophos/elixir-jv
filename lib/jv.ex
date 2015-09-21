defmodule JV do
  def find(path, filename) do
    data = File.read! filename
    json = Poison.Parser.parse! data
    path_match(path, json)
  end

  def find_all(path, [head|tail]) do
    {ok, result} = Poison.encode find(path, head)
    IO.puts result
    find_all(path, tail)
  end

  def find_all(path, []) do
    []
  end

  def path_match([], json) do
    json
  end

  def path_match(path, json) do
    top = hd path
    cond do
      # Treat these as matches
      top == "" or top == "." ->
        path_match(tl(path), json)
      # We have arrived at the end of the query and found a match.
      top == json ->
        json
      is_list(json) ->
        find_in_list(path, json)
      is_map(json) ->
        find_in_map(path, json)
    end
  end

  def find_in_list(path, json) do
    pos = hd path
    #pos = String.to_int(top)
    tj = List.to_tuple(json)
    path_match(tl(path), elem(tj, String.to_integer(pos)))
  end

  def find_in_map(path, json) do
    top = hd path
    path_match(tl(path), json[top])
  end

  def main(argv) do
    # FIXME: Add some options. Ideally, it'd be nice
    # to do YAML files, too.
    {_, args, _} = OptionParser.parse(argv)


    len = length args
    if len < 2 do
      IO.puts "Error: Path and Filename are both required"
      exit(1)
    end

    path = String.split(hd(args), "/")
    try do
      find_all(path, tl args)
    rescue
      e in RuntimeError -> IO.puts "Fatal error: #{e}"
    end
  end
end
