defmodule InvalidCurveAttack.Sender do

  def run(url) do
    project = Application.app_dir(:jose_invalid_curve_attack, Path.join(["priv", "sender"]))
    case ensure_node_modules(project) do
      true ->
        command = System.find_executable("node")
        script  = Path.join([project, "index.js"])
        port = Port.open({:spawn_executable, command}, [
          :stream, :in, :binary, :eof, :hide,
          { :args, [script, url] },
          { :cd, :erlang.binary_to_list(project) }
        ])
        extract_result(loop(port))
      error ->
        error
    end
  end

  defp ensure_node_modules(project) do
    if File.dir?(Path.join([project, "node_modules"])) do
      true
    else
      case ensure_yarn_exists() do
        {true, _} ->
          try do
            {_, 0} = System.cmd("yarn", ["install"], [cd: project])
            true
          catch
            error, reason ->
              {error, reason}
          end
        false ->
          {:error, "yarn and/or npm not found"}
      end
    end
  end

  defp ensure_yarn_exists() do
    try do
      {version, 0} = System.cmd("yarn", ["--version"])
      {true, String.strip(version)}
    catch
      :error, :enoent ->
        case ensure_npm_exists() do
          {true, _} ->
            if try_install_yarn() do
              try do
                {version, 0} = System.cmd("yarn", ["--version"])
                {true, String.strip(version)}
              catch
                :error, :enoent ->
                  false
              end
            else
              false
            end
          false ->
            false
        end
    end
  end

  defp ensure_npm_exists() do
    try do
      {version, 0} = System.cmd("npm", ["--version"])
      {true, String.strip(version)}
    catch
      :error, :enoent ->
        false
    end
  end

  defp try_install_yarn() do
    try do
      {_, 0} = System.cmd("npm", ["install", "--global", "yarn"])
      true
    catch
      :error, _ ->
        false
    end
  end

  defp loop(port) do
    loop(port, "")
  end

  defp loop(port, acc) do
    receive do
      { ^port, { :data, data } } ->
        loop(port, acc <> data)
      { ^port, :eof } ->
        send port, { self(), :close }
        receive do: ({ ^port, :closed } -> :ok)
        acc
    end
  end

  defp extract_result(output) do
    case Poison.decode!(output) do
      [ "ok", value ] ->
        {:ok, value}
      [ "ok" ] ->
        :ok
      [ "err", message ] ->
        raise %RuntimeError{message: message}
      [ "err" ] ->
        raise %RuntimeError{message: "unknown error"}
    end
  end

end