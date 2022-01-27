struct SensorsInput
    sensors::Vector{Function}

    function SensorsInput()
        sensors = Vector{Function}()

        push!(sensors, getAGE)
        push!(sensors, getRNG)

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

function (sensors::SensorsInput)(sensorNum::Number, sim, boid)
    sensorNum.sensors[sensorNum](sim, boid)
end
