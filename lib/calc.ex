defmodule IP.Calc do
  @spec call(index :: integer(), net :: String.t()) :: {:error, String.t()} | {:ok, String.t()}
  def call(index, net) do
    {net_addr, cidr} = parse_net(net)

    with true <- calc_cidr(cidr) > index do
      ip_by_index =
        (length(net_addr) - 1)
        |> calc_ip(net_addr, index, [])
        |> ip_to_string()

      {:ok, ip_by_index}
    else
      false -> {:error, "cidr exceeded"}
    end
  end

  defp parse_net(net_addr) do
    [addr_str, cidr_str] = String.split(net_addr, "/")

    addr =
      addr_str
      |> String.split(".")
      |> Enum.map(&String.to_integer(&1, 10))

    cidr = String.to_integer(cidr_str, 10)
    {addr, cidr}
  end

  defp calc_cidr(cidr), do: Bitwise.bsl(1, 32 - cidr)

  defp calc_ip(-1, [], _index, ip), do: Enum.reverse(ip)

  defp calc_ip(base, net, index, ip) do
    oct =
      base
      |> calc_base()
      |> calc_oct(index)

    [h | tail] = net

    (base - 1)
    |> calc_ip(tail, index, [h + oct | ip])
  end

  defp calc_base(base), do: Bitwise.bsl(1, 8 * base)

  defp calc_oct(base_div, index) do
    Integer.floor_div(index, base_div)
    |> rem(256)
  end

  defp ip_to_string(ip_oct) do
    Enum.join(ip_oct, ".")
    |> then(&"#{&1}/32")
  end
end
