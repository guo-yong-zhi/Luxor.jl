#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function randompoly(rad, n)
    result = Point[]
    for i in 1:n
        push!(result, Point(rand(-rad:rad), rand(-rad:rad)))
    end
    return polysortbyangle(result)
end

function testapoly(pos)
    @layer begin
    translate(pos)

    sethue("white")

    # try both regular and irregular polygons
    if rand(Bool)
        p1 = ngon(O, 80, rand(3:8), rand(0:pi/10:2pi), vertices=true)
    else
        p1 = star(O, 90, rand(3:12), 0.5, 0, vertices=true)
    end
    setline(1.5)

    # poly(p1, close=true, :fillstroke)
    # for p in p1
    #     @layer begin
    #     sethue("black")
    #     circle(p, 1, :fill)
    #     end
    # end


    randomline = [Point(rand(-50:50), -170), Point(rand(-50:50), 170)]


    # split the polygon
    twopolys = polysplit(p1, randomline[1], randomline[2])

    # draw each poly
    for ply in twopolys
        if length(ply) > 1
            @layer begin
            randomhue()
            poly(ply, close=true, :fill)
            end
        end
    end

    @layer begin
    sethue("red")
    setdash("dotted")
    line(randomline[1], randomline[2], :stroke)
    end

    end
end

fname = "polysplit.pdf"
width, height = 2000, 2000
Drawing(width, height, fname)
origin()
background("ivory")
setlinecap("round")
setopacity(0.6)

pagetiles = Tiler(width, height, 6, 5, margin=50)
for (pos, n) in pagetiles
    sethue("green")
    squircle(pos, pagetiles.tilewidth/2 - 2, pagetiles.tileheight/2 - 2, :stroke)
    testapoly(pos)
end

@test finish() == true
println("...finished test: output in $(fname)")
