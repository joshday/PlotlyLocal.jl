

function surface(z::AbstractMatrix; kw...)
    d = Dict(:z => z, :x => 1:size(z, 2), :y => 1:size(z, 1), :type => "surface")
    p = PlotlyVis([d], Dict())
    data!(p, 1; kw...)
    writehtml(p)
    p
end

function plot(x::AbstractVector, y::AbstractVector; linetype = :scatter, kw...)
    d = Dict(:x => x, :y => y, :type => linetype)
    p = PlotlyVis([d], Dict())
    data!(p, 1;kw...)
    writehtml(p)
    p
end

function plot(x::AbstractVector, y::AbstractMatrix; linetype = :scatter, kw...)
    d = Dict(:x => x, :y => y[:, 1], :type => linetype)
    dvec = [d]
    for j in 2:size(y, 2)
        push!(dvec, Dict(:x => x, :y => y[:, j], :type => linetype))
    end

    p = PlotlyVis(dvec, Dict())
    data!(p, 1;kw...)
    writehtml(p)
    p
end

# without specifying x
function plot(y::AbstractVector; linetype = :scatter, kw...)
    plot(1:length(y), y; linetype = linetype, kw...)
end

function plot(y::AbstractMatrix; linetype = :scatter, kw...)
    plot(1:size(y,1), y; linetype = linetype, kw...)
end
