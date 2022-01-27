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

function pop!(env::Environment, n::Number)
    for i in 1:n
        loc = findEmptyLoc(env)
        boid = Boid(loc)
        pop!(env, boid, loc)
    end
end

function pop!(env::Environment, boids::Vector{Boid})
    for boid in boids
        loc = findEmptyLoc(env)
        pop!(env, boid, loc)
    end
end

function pop!(env::Environment, boid::Boid, loc::Tuple{Number,Number})
    push!(env.population, boid)
    env.grid[loc...] = length(env.population)
end

#world size
#vec of pop
#steps per gen
#optional: obstacles
#optional: food?

function step(env::Environment, sim)
    # [boid() for boid in env.population]
    # ((x)->x()).(env.population)
    step,(env.population, Ref(sim))
    # use brain action levels to impact grid
end

function newGen(env::Environment)
    # take all alive boids which follow selection criteria
    # reproduce boids for new generation
    # wipe board & populate with new gen
end


function display(env::Environment)
    # go through grid and apply func to convert num to RGB
    return map(e->toRGB(e,env.population), env.grid)
    # save("tmp.png", colorview(RGB, rand(RGB,15,15)))
end

function toRGB(entry::Number, population::Vector{Boid})
    if iszero(entry)
        return RGB{Float64}(1.0,1.0,1.0)
    else
        return toRGB(population[entry])
    end
end
