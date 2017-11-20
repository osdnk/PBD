defmodule PBD do
  @moduledoc """
  Documentation for PBD.
  """

  @doc """
  Hello world.

  ## Examples

      iex> PBD.hello
      :world

  """
  def hello do
    :world
  end

  def example do
    {:ok, pid} = Postgrex.start_link(hostname: "localhost", username: "postgres", password: "postgres", database: "pbd")
    Postgrex.query!(pid, "SELECT * FROM conferences", [])
  end
end
