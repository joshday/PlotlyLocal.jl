module TestCode
using PlotlyLocal, Distributions, Colors

data = [Dict(:y => randn(100), :type => "bar"), Dict(:x => 1:100, :y => rand(100))]
layout = Dict(:title => "My Title")
plot(data, layout)

end #module
