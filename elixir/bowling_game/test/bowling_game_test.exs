defmodule BowlingGameTest do
  use ExUnit.Case

  defp assert_score(context, score) do
    assert GenServer.call(context[:pid], :score) == score
  end

  setup do
    {:ok, pid} = GenServer.start_link(BowlingGame, [])
    roll = fn pins -> GenServer.cast(pid, {:roll, pins}) end
    [pid: pid, roll: roll]
  end

  test "calling score with no rolls returns 0", context do
    assert_score(context, 0)
  end

  test "calling score with a single roll of 5", context do
    context[:roll].(5)
    assert_score(context, 5)
  end

  test "calling score with a single frame with rolls of 5 and 4", context do
    context[:roll].(5)
    context[:roll].(4)
    assert_score(context, 9)
  end

  test "calling score with a spare followed by a 5", context do
    context[:roll].(5)
    context[:roll].(5)
    context[:roll].(5)
    assert_score(context, 20)
  end

  test "calling score with a spare followed by another frame (5,4)", context do
    context[:roll].(5)
    context[:roll].(5)
    context[:roll].(5)
    context[:roll].(4)
    assert_score(context, 24)
  end

  test "calling score with a strike followed by another frame (5,4)", context do
    context[:roll].(10)
    context[:roll].(5)
    context[:roll].(4)
    assert_score(context, 28)
  end

  test "calling score with two strikes followed by another frame (5,4)", context do
    context[:roll].(10)
    context[:roll].(10)
    context[:roll].(5)
    context[:roll].(4)
    assert_score(context, 53)
  end

  test "calling score with adjacent values on different frames that add up to 10", context do
    context[:roll].(0)
    context[:roll].(5)
    context[:roll].(5)
    context[:roll].(4)
    assert_score(context, 14)
  end

end
