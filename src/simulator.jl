mutable struct Simulator
    simStep::UInt
    generation::UInt
    env::Environment
    frames # dict for vectors to collect frames/data from the env throughout the sim
end
