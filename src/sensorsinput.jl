struct SensorsInput
    sensors::Vector{Function}

    function SensorsInput()
        sensors = Vector{Function}()

        push!(sensors, getAGE)
        push!(sensors, getRNG)
        push!(sensors, getLMX)
        push!(sensors, getLMY)
        push!(sensors, getLX)
        push!(sensors, getLY)

        return new(sensors)
    end
end

Base.length(s::SensorsInput) = return length(s.sensors)

#+++++
# Available sensors
#+++++

function getAGE(sim, boid)
    return boid.age/sim.maxStep
end

function getRNG(sim, boid)
    return rand(0:0.01:1)
end

function getLMX(sim, boid)
    if boid.lastMoveDir == 2
        return 0.0
    elseif boid.lastMoveDir == 4
        return 1.0
    else
        return 0.5
    end
end

function getLMY(sim, boid)
    if boid.lastMoveDir == 1
        return 0.0
    elseif boid.lastMoveDir == 3
        return 1.0
    else
        return 0.5
    end
end

function getLX(sim, boid)
    return boid.location[1]/size(sim.env.grid)[1]
end

function getLY(sim, boid)
    return boid.location[2]/size(sim.env.grid)[2]
end

function getBDX(sim, boid)
    return min(boid.location[1], size(sim.env.grid)[1]-boid.location[1])/(size(sim.env.grid)[1]/2.0)
end

function getBDY(sim, boid)
    return min(boid.location[2], size(sim.env.grid)[2]-boid.location[2])/(size(sim.env.grid)[2]/2.0)
end

function (sensors::SensorsInput)(sensorNum::Number, sim, boid)
    sensorNum.sensors[sensorNum](sim, boid)
end
