#!/usr/bin/env julia

using Luxor, Colors

using Test

using Random
Random.seed!(42)

function spiral_logo_eps()
    @layer begin
    scale(.3, .3)
    r = 200
    setcolor("gray")
    for i in 0:pi/8:2pi
        @layer begin
        translate(r * cos(i), r * sin(i))
        rotate(i)
        julialogo()
        end
    end
    end
end

function expandingspiral_eps()
    @layer begin
    scale(.3, .3)
    r = 200
    for i in pi:pi/12:6pi
        @layer begin
        translate(i/3 * r * cos(i), i/3 * r * sin(i))
        scale(0.8, 0.8)
        rotate(i)
        julialogo()
        end
    end
    end
end

function dropshadow_eps()
    steps=20
    # white-gray ramp
    gramp = range(colorant"white", stop=colorant"gray60", length=steps)
    @layer begin
    r = 200
    setopacity(0.1)
    for i in 1:steps
        sethue(gramp[i])
        translate(-0.6, -0.5)
        julialogo(color=false)
    end
    julialogo()
    end
end

function colorgrid_eps()
    #cols = colormap("RdBu", 5; mid=0.5, logscale=false)
    #cols = sequential_palette(rand(10:360), 5, b=0.1)
    cols = distinguishable_colors(25)
    @layer begin
    c = 0
    for row in 100:100:500
        for column in 100:100:500
            @layer begin
            setcolor(color(cols[c+=1]))
            translate(row, column)
            scale(0.3, 0.3)
            julialogo(color=false)
            end
        end
    end
    end
end

function draw_logo(fname)
    Drawing(1600, 1600, fname)
    origin()
    background("white")

    translate(-500, -200)
    spiral_logo_eps()

    translate(750, 0)
    expandingspiral_eps()

    translate(-1000, 500)
    dropshadow_eps()

    translate(700, -100)
    colorgrid_eps()

    @test finish() == true
    println("...finished test: output in $(fname)")
end

draw_logo("julia-logo-draw-eps.eps")
