module TestCode
using PlotlyLocal

P = PlotlyLocal

data = [
    Dict(:x => 1:50, :y => randn(50), :name => "y1"),
    Dict(:x => 1:50, :y => rand(50))
]

layout = Dict(:title => "mytitle")
p = P.Plot(data, layout)
P.writehtml(p)

data = [Dict(:z => randn(10,10), :type => "surface")]
p = P.Plot(data, layout)
P.writehtml(p)

end #module
