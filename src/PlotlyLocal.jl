module PlotlyLocal

using Mustache, Colors
import JSON
export Plot

const plotlylocal = Pkg.dir("PlotlyLocal", "deps", "plotly-latest.min.js")
const plotlylatest = "https://cdn.plot.ly/plotly-latest.min.js"

const html_template = mt"""
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


type Plot
    data::Vector{Dict}
    layout::Dict
    plotlysource::ASCIIString
    function Plot(data, layout)
        new(data, layout, plotlylocal)
    end
end


#---------------------------------------------------------------# write and open
function writehtml(p::Plot; verbose::Bool = true)
    mypath = string(tempname(), "tempfile.html")

    myhtml = render(
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
    # open file
    open_file(mypath)
end

function open_file(filename)
    if OS_NAME == :Darwin
        run(`open $(filename)`)
    elseif OS_NAME == :Linux || OS_NAME == :FreeBSD
        run(`xdg-open $(filename)`)
    elseif OS_NAME == :Windows
        run(`$(ENV["COMSPEC"]) /c start $(filename)`)
    else
        warn("Showing plots is not supported on OS $(string(OS_NAME))")
    end
end

end # module


include("../test/testcode.jl")
