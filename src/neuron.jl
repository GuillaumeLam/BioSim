# abstract type AbstractNeuron end
#
# abstract type AbstractSensoryInput<:AbstractNeuron end
# abstract type AbstractInternalNeuron<:AbstractNeuron end
# abstract type AbstractActionOutput<:AbstractNeuron end
#
# #pdf = population gradient foward
# struct PDF<:AbstractSensoryInput
#
# end

# mutable struct Neuron<:AbstractInternalNeuron
mutable struct Neuron
    output::Float16
    driven::Bool
    Neuron(driven::Bool) = new(0.5, driven)
end
