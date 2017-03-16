defmodule NervesLinkBlox.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "rpi3"

  def project do
    [app: :nerves_linkblox,
     version: "0.0.1",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.3.0"],
     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps() ++ system(@target)]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {NervesLinkBlox, []},
     applications: [:logger, 
                    :nerves_start_network,
                    :nerves,
                    :nerves_system_br,  
                    :erlang_ale,
                    :LinkBlox]]
  end

  def deps do
    [{:nerves, "~> 0.5.0"},
     {:nerves_start_network, github: "mdsebald/nerves_start_network"},
     {:LinkBlox, github: "mdsebald/LinkBlox"}]
  end

  def system(target) do
    [{:"nerves_system_#{target}", "~> 0.11.0"}]
  end

  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

end
