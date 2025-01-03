defmodule CleanUnroll.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      {Finch, name: CleanUnroll.Finch}
    ]

    opts = [strategy: :one_for_one, name: CleanUnroll.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
