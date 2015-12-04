# PlotlyLocal

[![Build Status](https://travis-ci.org/joshday/PlotlyLocal.jl.svg?branch=master)](https://travis-ci.org/joshday/PlotlyLocal.jl)


The main function defined in this package is `plot(data, layout)`.

Plotly plots are fully specified by

- `data`: `Vector` of `Dict`s, each represents a trace
- `layout`: `Dict`  

They keys inside of the dictionaries need to match the attributes from the Plotly documentation.  Each JSON object is created by a Julia `Dict`, so nested objects are created by nested `Dict`s.

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

To plot inline within [Jupyter notebooks](http://jupyter.org/) use the `iplot` method in place of `plot`.

The dictionary structure will look something like this when converted to JSON:

```
var data = [
  {
    y: [0.118431, 0.660444, ...]
  },
  {
    y: [0.87696, 0.385333, ...],
    marker: {
      color: "000000"
    }
  }
]

var layout = {
  title: "My Title"
}
```

# Thanks
A big thank you to the folks at [Plotly](https://plot.ly) for going open source!
