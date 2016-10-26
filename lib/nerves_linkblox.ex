defmodule NervesLinkBlox do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # worker(NervesLinkblox.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NervesLinkblox.Supervisor]
    Supervisor.start_link(children, opts)

    # Just start up network interface, for now
    # {_, _} = Nerves.Networking.setup :eth0
    # {:ok, self}
  end

end
