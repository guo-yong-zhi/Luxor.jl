#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function julia_logo_test(fname)
    Drawing(1000, 1000, fname)
    origin()
    background("white")
    for (pos, n) in Tiler(1000, 1000, 2, 2)
        @layer begin
        translate(pos - Point(150, 100))
        if n == 1
            julialogo()
            fillpath()
        elseif n == 2
            randomhue()
            setline(0.3)
            julialogo(action=:stroke)
        elseif n == 3
            sethue("orange")
            julialogo(color=false)
        elseif n == 4
            julialogo(action=:clip)
            setopacity(0.6)
            for i in 1:400
                randomhue()
                @layer begin
                box(Point(rand(0:250), rand(0:250)), 350, 5, :fill)
                end
            end
            clipreset()
        end
        end
    end
    @test finish() == true
end

fname="julia-logo-drawing.pdf"
julia_logo_test(fname)
println("...finished test: output in $(fname)")
