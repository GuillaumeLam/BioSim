using BioSim

env = Environment(10)

BioSim.pop!(env,20)

BioSim.display(env)

sim = Simulator(env,maxStep=100,maxGen=100)

BioSim.run(sim)

BioSim.getSimGif(sim,"test0.gif")
