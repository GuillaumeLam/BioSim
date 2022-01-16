# tmp struct for building of brain
# this struct allows us to keep track of connections
struct Node
    remappedNumber::Int
    numOutputs::Int
    numSelfInputs::Int
    numSensorInORNeurons::Int
end
