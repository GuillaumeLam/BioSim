mutable struct Simulator
    simStep::Number
    maxStep::Number
    generation::Number
    maxGen::Number
    env::Environment
    anim::Animation # dict for vectors to collect frames/data from the env throughout the sim

    Simulator(env::Environment; maxStep::Number=1000, maxGen::Number=10000) =
        new(0,maxStep,0,maxGen,env,Plots.Animation())
end

function (sim::Simulator)()
    if sim.simStep == sim.maxStep
        newGen(sim)
    else
        g = display(sim.env)
        img = colorview(RGB, g)
        plot(img)
        Plots.frame(sim.anim)

        # push other stats of environment

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
    while sim.generation < sim.maxGen
        sim()
        println("$(sim.generation*100/sim.maxGen)%")
    end
end

function getSimGif(sim::Simulator, filename::String)
    # push to folder
    gif(sim.anim, filename, fps = 24)
end
