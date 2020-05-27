"""
    barchart(values;
            boundingbox = BoundingBox(O + (-250, -120), O + (250, 120)),
            bargap=10,
            margin = 5,
            border=false,
            labels=false,
            labelfunction = (values, i, lowpos, highpos, barwidth, scaledvalue) -> begin
                    label(string(values[i]), :n, highpos, offset=10)
              end,
            barfunction =  (values, i, lowpos, highpos, barwidth, scaledvalue) -> begin
                @layer begin
                    setline(barwidth)
                    line(lowpos, highpos, :stroke)
                end
              end)

Draw a barchart where each bar is the height of a value in the `values` array. The bars
will be scaled to fit in a bounding box.

Text labels are drawn if the keyword `labels=true`.

The function returns a vector of points; each is the bottom center of a bar.

Draw a Fibonacci sequence as a barchart:

```
fib(n) = n > 2 ? fib(n - 1) + fib(n - 2) : 1
fibs = fib.(1:15)
@draw begin
    fontsize(12)
    barchart(fibs, labels=true)
end
```
To control the drawing of the text and bars, define functions that process the
end points:

`mybarfunction(values, i, lowpos, highpos, barwidth, scaledvalue)`

`mylabelfunction(values, i, lowpos, highpos, barwidth, scaledvalue)`

and pass them like this:

```julia
barchart(vals, barfunction=mybarfunction)
barchart(vals, labelfunction=mylabelfunction)
```

"""
function barchart(values;
        boundingbox = BoundingBox(O + (-250, -120), O + (250, 120)),
        bargap=10,
        margin = 5,
        border=false,
        labels=false,        labelfunction = (values, i, lowpos, highpos, barwidth, scaledvalue) -> begin
                label(string(values[i]), :n, highpos, offset=10)
            end,
        barfunction =  (values, i, lowpos, highpos, barwidth, scaledvalue) -> begin
            @layer begin
                setline(barwidth)
                line(lowpos, highpos, :stroke)
            end
            end)
    # start
    minvalue, maxvalue = extrema(values)
    barchartwidth  = boxwidth(boundingbox)  - 2bargap - 2margin
    barchartheight = boxheight(boundingbox) - 2margin
    barwidth = (barchartwidth - 2bargap)/length(values)
    # if all bars are equal height, this will force a range
    minbarrange = minvalue - abs(minvalue)
    maxbarrange = maxvalue + abs(maxvalue)
    hpositions = between.(
        boxbottomleft(boundingbox - (0, margin)),
        boxbottomright(boundingbox - (0, margin)),
        # skip first and last, then take every other one, which is at halfway
        range(0.0, 1.0, length=2length(values) + 1))[2:2:end-1]
    @layer begin
        if border
            box(boundingbox, :stroke)
        end
        for i in 1:length(values)
            scaledvalue = rescale(values[i], minbarrange, maxbarrange) * barchartheight
            lowposition = hpositions[i]
            highposition = lowposition - (0, scaledvalue) # -y coord
            barfunction(values, i, lowposition, highposition, barwidth, scaledvalue)
            labels && labelfunction(values, i, lowposition, highposition, barwidth, scaledvalue)
        end
    end
    return (positions = hpositions)
end

# this old version is deprecated as of v2.0.0

function bars(values::Array,
    yheight = 200,
    xwidth = 25,

    barfunction   = (bottom::Point, top::Point, value;
        extremes=extrema(values), barnumber=1, bartotal=0) -> begin
                setline(xwidth)
                line(bottom, top, :stroke)
            end,

    labels::Bool=true,

    labelfunction = (bottom::Point, top::Point, value;
        extremes=extrema(values), barnumber=1, bartotal=0) -> begin
            t = string(round(value, digits=2))
            textoffset = textextents(t)[4]
            fontsize(10)
            if top.y < 0
                tp = Point(top.x, min(top.y, bottom.y) - textoffset)
            else
                tp = Point(top.x, max(top.y, bottom.y) + textoffset)
            end
            text(t, tp, halign=:center, valign=:middle)
        end)
    # end keyword args
    x = O.x
    mn, mx = extrema(values)
    isapprox(mn, mx, atol=0.00001) && (mx = mn + 100) # better show something than nothing
    for (n, v) in enumerate(values)
        # remember y increases downwards by default
        bottom = Point(x, -rescale(min(v, 0), min(0, mn), mx, 0, yheight))
        top    = Point(x, -rescale(max(v, 0), min(0, mn), mx, 0, yheight))
        barfunction(bottom, top, v, extremes=extrema(values), barnumber=n, bartotal=length(values))
        labels && labelfunction(bottom, top, v, extremes=extrema(values), barnumber=n, bartotal=length(values))
        x += xwidth
    end
end
