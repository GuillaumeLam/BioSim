mutable struct Environment
    population::Vector{Boid}
    grid::Matrix{UInt}

    Environment(n::Number) = new(Vector{Boid}(),zeros(UInt,n,n))
    Environment(m::Number, n::Number) = new(Vector{Boid}(),zeros(UInt,m,n))
end

function Base.size(env::Environment)
    return size(env.grid)
end

function findEmptyLoc(env::Environment)
    loc = nothing
    max_x,max_y = size(env)

    # add check to make sure there are empty pos w/ findFirst

    while isnothing(loc)
        x,y = rand(1:max_x), rand(1:max_y)

        if iszero(env.grid[x,y])
            loc = (x,y)
        end
    end

    return loc
end

function populate!(env::Environment, n::Number)
    for i in 1:n
        loc = findEmptyLoc(env)
        boid = Boid(loc)
        populate!(env, boid, loc)
    end
end

function populate!(env::Environment, boids::Vector{Boid})
    for boid in boids
        loc = findEmptyLoc(env)
        populate!(env, boid, loc)
    end
end

function populate!(env::Environment, boid::Boid, loc::Tuple{Number,Number})
    push!(env.population, boid)
    env.grid[loc...] = length(env.population)
end

#world size
#vec of pop
#steps per gen
#optional: obstacles
#optional: food?

function (env::Environment)()
    env.population.()
    # use brain action levels to impact grid
end

function newGen(env::Environment)
    # take all alive boids which follow selection criteria
    # reproduce boids for new generation
    # wipe board & populate with new gen
end
