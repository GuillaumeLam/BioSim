struct Boid
    location::Tuple{Int,Int}
    genome::Vector{String}
    brain::NeuralNet
end

# reproduction
# map genome to color for visual
