#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function run_line_intersection_test(fname)
    Drawing(2000, 2000, fname)
    origin()
    sethue("magenta")
    setline(.2)
    fontsize(4)
    tiles = Tiler(1000, 1000, 10, 10)
    for (pos, n) in tiles
        @layer begin
        randomhue()
        translate(pos)
        topleft = Point(-tiles.tilewidth/2, -tiles.tileheight/2)
        bottomright = Point(tiles.tilewidth/2, tiles.tileheight/2)
        a = randompoint(topleft, bottomright)
        b = randompoint(topleft, bottomright)
        c = randompoint(topleft, bottomright)
        d = randompoint(topleft, bottomright)
        line(a, b, :stroke)
        line(c, d, :stroke)
        (flag, ip) = intersectionlines(a, b, c, d, crossingonly=true)
        text("the lines $(flag ? "do" : "don't") cross", O)
        if flag
            @layer begin
            setline(.5)
            setdash("dot")
            if distance(a, ip) < distance(b, ip)
                arrow(a, ip, arrowheadlength=1)
            else
                arrow(b, ip, arrowheadlength=1)
            end
            if distance(c, ip) < distance(d, ip)
                arrow(c, ip, arrowheadlength=1)
            else
                arrow(d, ip, arrowheadlength=1)
            end
            circle(ip, 2, :fill)
            end
        else
            if ip != O
                box(ip, 2, 2, :fill)
            end
            dist = distance(O, ip)
            if dist > 500
                text("intersection point is $(dist) units away", O + (0, 10))
            end
        end
        end
    end
    @test finish() == true

end

fname = "line-intersection-options.pdf"
run_line_intersection_test(fname)
println("...finished test: output in $(fname)")
