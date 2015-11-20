module TestCode
using PlotlyLocal, Distributions, Colors

P = PlotlyLocal

data = [
    Dict(:x => 1:50, :y => randn(50), :name => "y1"),
    Dict(:x => 1:50, :y => rand(50)),
    Dict(:y => cumsum(randn(47)), :marker => Dict(:color => hex(colorant"black")))
]

layout = Dict(:title => "mytitle")

p = P.PlotlyVis(data, layout)
P.writehtml(p)



P.surface(sprand(30, 20, .1))
P.plot(1:100, randn(100); linetype = "scattergl")
P.plot(randn(10,4))
P.plot(["a", "b", "c"], [1, 10, 4]; linetype = "bar")


end #module
