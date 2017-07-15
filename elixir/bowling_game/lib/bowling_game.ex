defmodule BowlingGame do
  use GenServer
  
  def handle_cast({:roll, pins}, state) do
    {:noreply, state ++ [pins] }
  end

  def handle_call(:score, _from, state) do
    {:reply, calculate_score(state), state}
  end

  defp calculate_score([]) do
    0
  end

  defp calculate_score([ 10 | tail ]) do
    [one, two | _ ] = tail
    10 + one + two + calculate_score(tail)
  end
  
  defp calculate_score([ one, two | tail ]) when one + two == 10 do
    [ three | _ ] = tail
    10 + three + calculate_score(tail)
  end

  defp calculate_score([one, two | tail]) do
    one + two + calculate_score(tail)
  end

  defp calculate_score([head]) do
    head
  end
end
