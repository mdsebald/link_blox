defmodule NervesLinkBlox.Mixfile do
  use Mix.Project

  @target System.get_env("MIX_TARGET") || "host"

  Mix.shell.info([:green, """
  Mix environment
    MIX_TARGET:   #{@target}
    MIX_ENV:      #{Mix.env}
  """, :reset])

  def project do
    [app: :nerves_link_blox,
     version: "0.3.0",
     elixir: "~> 1.6",
     target: @target,
     archives: [nerves_bootstrap: "~> 1.0.0-rc.3"],
     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",
     lockfile: "mix.lock.#{@target}",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(@target),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application, do: application(@target)

  # Specify target specific application configurations
  # It is common that the application start function will start and supervise
  # applications which could cause the host to fail. Because of this, we only
  # invoke NervesLinkBlox.start/2 when running on a target.

  def application("host") do
     [mod: {NervesLinkBlox.Application, []},
      extra_applications: []]
  end
  def application(_target) do
     [mod: {NervesLinkBlox.Application, []},
     extra_applications: [:logger,
                          :nerves_init_gadget,
                          :LinkBlox]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  def deps do
    deps(@target)
  end

  # Specify target specific dependencies
  def deps("host"), do: 
    [
      {:LinkBlox, github: "mdsebald/LinkBlox"}
    ]
  def deps(target) do
    [
      {:shoehorn, "~> 0.2"},
      {:nerves_init_gadget, "~> 0.3.0"},
      {:nerves_ntp, "~> 0.1.0", runtime: false},
      {:LinkBlox, github: "mdsebald/LinkBlox"}
    ] ++ system(target)
  end

  def system("rpi"), do: [{:nerves_system_rpi, ">= 0.0.0", runtime: false}]
  def system("rpi0"), do: [{:nerves_system_rpi0, ">= 0.0.0", runtime: false}]
  def system("rpi2"), do: [{:nerves_system_rpi2, ">= 0.0.0", runtime: false}]
  def system("rpi3"), do: [{:nerves_system_rpi3, ">= 0.0.0", runtime: false}]
  def system("bbb"), do: [{:nerves_system_bbb, ">= 0.0.0", runtime: false}]
  def system("linkit"), do: [{:nerves_system_linkit, ">= 0.0.0", runtime: false}]
  def system("ev3"), do: [{:nerves_system_ev3, ">= 0.0.0", runtime: false}]
  def system("qemu_arm"), do: [{:nerves_system_qemu_arm, ">= 0.0.0", runtime: false}]
  def system(target), do: Mix.raise "Unknown MIX_TARGET: #{target}"

  # We do not invoke the Nerves Env when running on the Host
  def aliases("host"), do: []
  def aliases(_target) do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
    |> Nerves.Bootstrap.add_aliases()
  end

end

