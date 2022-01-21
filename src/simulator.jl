mutable struct Simulator{N<:Number}
    simStep::N
    maxStep::N
    generation::N
    maxGen::N
    env::Environment
    frames # dict for vectors to collect frames/data from the env throughout the sim

    Simulator(env::Environment, maxStep::N=1000, maxGen::N=10000) where {N<:Number} =
        new(0,maxStep,0,maxGen,env,Dict{String,Vector{Int}}())
end

function (sim::Simulator)()
    if sim.simStep == sim.maxStep
        newGen(sim)
    else
        # add stats to frame stack
        sim.simStep += 1
        sim.env()
    end
end

function newGen(sim::Simulator)
    sim.simStep = 0
    sim.generation += 1
    newGen(sim.env)
end

function run(sim::Simulator)
    while sim.generation > sim.maxGen
        sim()
    end
end
