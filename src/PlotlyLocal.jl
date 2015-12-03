module PlotlyLocal

import JSON
export PlotlyVis, layout, layout!, data, data!, plot, plot!, iplot

const plotlylocal = Pkg.dir("PlotlyLocal", "deps", "plotly-latest.min.js")

#--------------------------------------------------------------------# PlotlyVis
type PlotlyVis
    data::Vector{Dict}         # vector of traces
    layout::Dict               # optional, can be empty
end


#-----------------------------------------------------------------------# layout
layout!(p::PlotlyVis, d::Associative) = merge!(p.layout, d)
layout!(p::PlotlyVis; kw...) = layout!(p, Dict(kw))


#-------------------------------------------------------------------------# data
# Edit the i-th trace
data!(p::PlotlyVis, i::Int, d::Associative) = merge!(p.data[i], d)
data!(p::PlotlyVis, i::Int; kw...) = merge!(p.data[i], Dict(kw))

# Add a new trace
data!(p::PlotlyVis, trace::Associative) = push!(p.data, trace)


#-------------------------------------------------------------------------# plot
function plot{T<:Associative}(data::Vector{T}, layout::Associative)
    p = PlotlyVis(data, layout)
    writehtml(p)
    p
end

# refresh plot after changes
plot!(p::PlotlyVis) = writehtml(p)


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

#-------------------------------------------------------------------------# iplot
function iplot{T<:Associative}(data::Vector{T}, layout::Associative)
    p = PlotlyVis(data, layout)

    init_notebook_mode = """
    <script type="text/javascript">
        require=requirejs=define=undefined;
    </script>
    <script type="text/javascript">
        $(readall(PlotlyLocal.plotlylocal))
    </script>
    """

    myhtml = """
    <div class="div1 loading"> Drawing...</div>
    <div id="div1"></div>
    <script type="text/javascript">
        var data = $(JSON.json(p.data))
        var layout = $(JSON.json(p.layout))
        Plotly.newPlot('div1', data, layout);
        \$(".div1.loading").remove();
  </script>
  """

  Base.HTML(init_notebook_mode * myhtml)
end

end # module
