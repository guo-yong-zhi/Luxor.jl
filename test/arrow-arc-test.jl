#!/usr/bin/env julia

using Luxor, Random

Random.seed!(42)

using Test

function test_circular_arrows_1(pos)
    @layer begin
    froma = rescale(rand(1:100), 1, 100, 0, 2pi)
    toa =   rescale(rand(1:100), (1, 100), (0, 2pi))
    sethue("black")
    arrow(pos, 100, froma, toa, linewidth=rand(1:6), arrowheadlength=rand(10:30))
    text(string("from: ", round(rad2deg(froma), digits=1)), pos)
    text(string("to: ", round(rad2deg(toa), digits=1)), pos.x, pos.y+10)
    sethue("magenta")
    arrow(pos, 100, toa, froma; linewidth=rand(1:6), arrowheadlength=rand(10:30))
    text(string("from: ", round(rad2deg(toa), digits=1)), pos.x, pos.y+20)
    text(string("to: ", round(rad2deg(froma), digits=1)), pos.x, pos.y+30)
    end
end

function test_circular_arrows_2(pos, w)
  sethue("black")
  for a in 50:10:w
    randomhue()
    starta = rand(0:pi/12:2pi)
    finisha = rand(0:pi/12:2pi)
    arrow(pos, a, starta, finisha, linewidth=rand(1:6), arrowheadlength=rand(1:20))
  end
end

function arrow_arc_test(fname)
  pagewidth, pageheight = 2000, 2000
  Drawing(pagewidth, pageheight, fname)
  origin() # move 0/0 to center
  background(1, 1, 0.9, 1)
  setopacity(0.5)
  setline(2)
  pagetiles = Tiler(pagewidth, pageheight, 4, 4, margin=50)
  for (pos, n) in pagetiles
    if isodd(n)
      test_circular_arrows_1(pos)
    else
      test_circular_arrows_2(pos, pagetiles.tilewidth/2)
    end
  end

  # test Bezier arrow
  setopacity(1.0)
  sethue("red")
  arrow(pagetiles[1][1], pagetiles[3][1], pagetiles[6][1], pagetiles[7][1],
    linewidth=5,
    arrowheadlength=50,
    arrowheadfill = false,
    arrowheadangle=π/4,
    startarrow=true)

  @test finish() == true
  println("...finished arrow-test: saved in $(fname)")
end

fname = "arrow-arctest.png"
arrow_arc_test(fname)
