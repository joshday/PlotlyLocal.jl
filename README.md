# PlotlyLocal

[![Build Status](https://travis-ci.org/joshday/PlotlyLocal.jl.svg?branch=master)](https://travis-ci.org/joshday/PlotlyLocal.jl)


The main function defined in this package is `plot(data, layout)`.

Plotly plots are fully specified by

- `data`: `Vector` of `Dict`s
- `layout`: `Dict`  

They keys inside of the dictionaries need to match the attributes from the Plotly documentation:

- https://plot.ly/javascript/reference/



Example:
```julia
using PlotlyLocal, Colors

data = [
    Dict(:y => randn(100)),
    Dict(:y => rand(100), :marker => Dict(:color => hex(colorant"black")))
]

layout = Dict(:title => "My Title")

plot(data, layout)
```
