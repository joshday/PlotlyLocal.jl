module TestCode
using PlotlyLocal, Distributions, Colors

data = [Dict(:y => randn(100), :type => "bar"), Dict(:x => 1:100, :y => rand(100))]
layout = Dict(:title => "My Title")
p = plot(data, layout)
data!(p, Dict(:y => cumsum(randn(100)), :x => 1:100))
plot!(p)

data = [Dict(:z => randn(100,100), :type => :surface)]
p = plot(data, Dict())
layout!(p, title = "New Title!")
plot!(p)

end #module
