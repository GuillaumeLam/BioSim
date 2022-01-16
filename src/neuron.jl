abstract type AbstractNeuron end

abstract type AbstractSensoryInput<:AbstractNeuron end
abstract type AbstractInternalNeuron<:AbstractNeuron end
abstract type AbstractActionOutput<:AbstractNeuron end

#pdf = population gradient foward
struct PDF<:AbstractSensoryInput

end

struct Neuron<:AbstractInternalNeuron

end
