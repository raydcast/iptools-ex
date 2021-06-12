defmodule Mix.Tasks.Ip.Calc do
  def run(args) do
    case args do
      [client_index, net_addr] ->
        String.to_integer(client_index, 10)
        |> IP.Calc.call(net_addr)
        |> calc()

      [_] ->
        raise "Missing net address param"

      [] ->
        raise "Missing client index and net address params"
    end
  end

  defp calc({:ok, ip}), do: IO.puts(ip)
  defp calc({:error, reason}), do: raise(reason)
end
