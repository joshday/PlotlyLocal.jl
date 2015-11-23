module PlotlyLocal

import Mustache, JSON
export PlotlyVis, layout, layout!, data, data!, surface, plot

const plotlylocal = Pkg.dir("PlotlyLocal", "deps", "plotly-latest.min.js")

#--------------------------------------------------------------------# PlotlyVis
type PlotlyVis
    data::Vector{Dict}         # vector of traces
    layout::Dict               # optional, can be empty
end

#-----------------------------------------------------------------------# layout
function layout!(p::PlotlyVis; kw...)
    for k in kw
        p.layout[k[1]] = k[2]
    end
end

#-------------------------------------------------------------------------# data
function data!(p::PlotlyVis, i::Int; kw...)
    @assert i <= length(p.data)
    for k in kw
        p.data[i][k[1]] = k[2]
    end
end

#-------------------------------------------------------------------------# plot
function plot{T<:Associative}(data::Vector{T}, layout::Associative)
    p = PlotlyVis(data, layout)
    writehtml(p)
    p
end


#---------------------------------------------------------------# write and open
function writehtml(p::PlotlyVis, dest::AbstractString = tempname(); verbose::Bool = false)
    mypath = string(dest, "tempfile.html")

    myhtml = """
    <!DOCTYPE html>
    <html>
    <head>
      <title>PlotlyLocal Visualization</title>
      <script src = "$plotlylocal"></script>
    </head>

    <body>
      <div id="div1">
      <script>
        var data = $(JSON.json(p.data))
        var layout = $(JSON.json(p.layout))
        Plotly.newPlot('div1', data, layout);
      </script>
    </body>
    </html>
    """

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

end # module


include("../test/testcode.jl")
