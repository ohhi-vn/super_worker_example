defmodule SuperWorkerExampleTest do
  use ExUnit.Case
  doctest SuperWorkerExample

  test "greets the world" do
    assert SuperWorkerExample.hello() == :world
  end
end
