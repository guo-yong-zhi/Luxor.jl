#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function test_boxes(fname)
    pagewidth, pageheight = 1200, 1400

    Drawing(pagewidth, pageheight, fname)
    origin() # move 0/0 to center
    background("ivory")
    setopacity(0.5)
    @layer begin
    t = Tiler(1000, 1000, 20, 20)
    for (pos, n) in t
        randomhue()
        box(pos, rand(5:50), rand(5:50), rand(5:55), :fillpreserve)
        randomhue()
        rotate(2pi * rand())
        strokepath()
    end

    end

    sethue("black") # hide
    setline(4)
    # round corners with different radii
    box(O, 200, 150, collect(range(5, 20, step=4)), :stroke)

    for (pos, n) in t
        randomhue()

        polysmooth(box(O, 200, 150, vertices=true), 10, :stroke)

        box(pos, rand(5:50), rand(5:50), rand(5:15), :path)
        randomhue()
        strokepath()
        p = pathtopoly()
        for pl in p
            prettypoly(pl, :fill, () -> circle(O, 5, :stroke))
        end
    end

    @test finish() == true
    println("...finished boxtest, saved in $(fname)")
end

fname = "box-test.png"
test_boxes(fname)
