module PlotlyLocal

import Mustache, JSON
export PlotlyVis, layout!, data!

const plotlylocal = Pkg.dir("PlotlyLocal", "deps", "plotly-latest.min.js")
const plotlylatest = "https://cdn.plot.ly/plotly-latest.min.js"

const html_template = Mustache.@mt_str """
<!DOCTYPE html>
<html>
<head>
  <title>PlotlyLocal Visualization</title>
  <script src = {{{:plotlysource}}}></script>
</head>

<body>
  <div id="div1">
  <script>
    var data = {{{:data}}}
    var layout = {{{:layout}}}
    Plotly.newPlot('div1', data, layout);
  </script>
</body>
</html>
"""


type PlotlyVis
    data::Vector{Dict}         # vector of traces
    layout::Dict               # completely optional
    plotlysource::ASCIIString  # plotlylocal or plotlylatest

    function PlotlyVis(data, layout)
        new(data, layout, plotlylocal)
    end
end

"Add/change keys for `p.layout::Dict`"
function layout!(p::PlotlyVis; kw...)
    for k in kw
        p.layout[k[1]] = k[2]
    end
end

"Add/change keys for the i-th trace in `p.data`"
function data!(p::PlotlyVis, i::Int; kw...)
    @assert i <= length(p.data)
    for k in kw
        p.data[i][k[1]] = k[2]
    end
end



#---------------------------------------------------------------# write and open
function writehtml(p::PlotlyVis, dest::AbstractString = tempname(); verbose::Bool = false)
    mypath = string(dest, "tempfile.html")

    myhtml = Mustache.render(
        html_template,
        plotlysource = JSON.json(p.plotlysource),
        data = JSON.json(p.data),
        layout = JSON.json(p.layout)
    )

    touch(mypath)
    outfile = open(mypath, "w")
    write(outfile, myhtml)
    close(outfile)

    verbose && println(myhtml)
    open_file(mypath)
end

function open_file(filename)
    @osx_only   return run(`open $(filename)`)
    @linux_only return run(`xdg-open $(filename)`)
    @windows_only return run(`$(ENV["COMSPEC"]) /c start $(filename)`)
    warn("Unknown OS... cannot open browser window.")
end

include("plot.jl")

end # module


include("../test/testcode.jl")
