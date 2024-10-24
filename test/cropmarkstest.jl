#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function cropmarkstest(fname)
    Drawing(1300, 1300, fname)
    origin()
    background("ivory")
    sethue("grey80")
    box(O, 1200, 1200, :fill)
    tiles = Tiler(600, 600, 3, 3, margin=30)
    for (pos, n) in tiles
        @layer begin
        translate(pos)
        randomhue()
        setopacity(rand())
        box(O, tiles.tilewidth - 25, tiles.tileheight - 25, :fill)
        cropmarks(O, tiles.tilewidth - 25, tiles.tileheight - 25)
        clipreset()
        end
    end
    cropmarks(O, 1200, 1200)
    @test finish() == true
end

fname = "cropmarkstest.pdf"
cropmarkstest(fname)
println("...finished test: output in $(fname)")
