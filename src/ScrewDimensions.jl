module ScrewDimensions
using DataFrames
using Unitful
using UnitfulRecipes
using RecipesBase

export diagonal_length


"""
```SCREWS```

A table of screw dimensions, from

http://www.emuge-franken-bg.com/attachments/article/97/15%20Gewindetabellen.pdf

and

https://en.wikipedia.org/wiki/Unified_Thread_Standard
"""
const SCREWS = DataFrame(;
                         name=Symbol[],
                         nominal_diameter=empty([1.0]u"mm"), # d = D
                         pitch=empty([1.0]u"mm"), # P
                         average_diameter=empty([1.0]u"mm"), # d_2 = D_2
                         outer_minor=empty([1.0]u"mm"), # d_3
                         inner_minor=empty([1.0]u"mm"), # D_1
                         outer_depth=empty([1.0]u"mm"), # h_3
                         inner_depth=empty([1.0]u"mm"), # H
                         rounding=empty([1.0]u"mm"), # R
                        )

push!(SCREWS, (:M1,            1u"mm",   0.25u"mm", 0.838u"mm",  0.693u"mm",  0.729u"mm",  0.153u"mm", 0.135u"mm", 0.036u"mm"))
push!(SCREWS, (Symbol("M1.1"), 1.1u"mm", 0.25u"mm", 0.938u"mm",  0.793u"mm",  0.829u"mm",  0.153u"mm", 0.135u"mm", 0.036u"mm"))
push!(SCREWS, (Symbol("M1.2"), 1.2u"mm", 0.25u"mm", 1.038u"mm",  0.893u"mm",  0.929u"mm",  0.153u"mm", 0.135u"mm", 0.036u"mm"))
push!(SCREWS, (Symbol("M1.4"), 1.4u"mm", 0.3u"mm",  1.205u"mm",  1.032u"mm",  1.075u"mm",  0.184u"mm", 0.162u"mm", 0.043u"mm"))
push!(SCREWS, (Symbol("M1.6"), 1.6u"mm", 0.35u"mm", 1.373u"mm",  1.171u"mm",  1.221u"mm",  0.215u"mm", 0.189u"mm", 0.051u"mm"))
push!(SCREWS, (Symbol("M1.8"), 1.8u"mm", 0.35u"mm", 1.573u"mm",  1.371u"mm",  1.421u"mm",  0.215u"mm", 0.189u"mm", 0.051u"mm"))
push!(SCREWS, (:M2,            2u"mm",   0.4u"mm",  1.740u"mm",  1.509u"mm",  1.567u"mm",  0.245u"mm", 0.217u"mm", 0.058u"mm"))
push!(SCREWS, (Symbol("M2.2"), 2.2u"mm", 0.45u"mm", 1.908u"mm",  1.648u"mm",  1.713u"mm",  0.276u"mm", 0.244u"mm", 0.065u"mm"))
push!(SCREWS, (Symbol("M2.5"), 2.5u"mm", 0.45u"mm", 2.208u"mm",  1.948u"mm",  2.013u"mm",  0.276u"mm", 0.244u"mm", 0.065u"mm"))
push!(SCREWS, (:M3,            3u"mm",   0.5u"mm",  2.675u"mm",  2.387u"mm",  2.459u"mm",  0.307u"mm", 0.271u"mm", 0.072u"mm"))
push!(SCREWS, (Symbol("M3.5"), 3.5u"mm", 0.6u"mm",  3.110u"mm",  2.764u"mm",  2.850u"mm",  0.368u"mm", 0.325u"mm", 0.087u"mm"))
push!(SCREWS, (:M4,            4u"mm",   0.7u"mm",  3.545u"mm",  3.141u"mm",  3.242u"mm",  0.429u"mm", 0.379u"mm", 0.101u"mm"))
push!(SCREWS, (Symbol("M4.5"), 4.5u"mm", 0.75u"mm", 4.013u"mm",  3.580u"mm",  3.688u"mm",  0.460u"mm", 0.406u"mm", 0.108u"mm"))
push!(SCREWS, (:M5,            5u"mm",   0.8u"mm",  4.480u"mm",  4.019u"mm",  4.134u"mm",  0.491u"mm", 0.433u"mm", 0.115u"mm"))
push!(SCREWS, (:M6,            6u"mm",   1u"mm",    5.350u"mm",  4.773u"mm",  4.917u"mm",  0.613u"mm", 0.541u"mm", 0.144u"mm"))
push!(SCREWS, (:M7,            7u"mm",   1u"mm",    6.350u"mm",  5.773u"mm",  5.917u"mm",  0.613u"mm", 0.541u"mm", 0.144u"mm"))
push!(SCREWS, (:M8,            8u"mm",   1.25u"mm", 7.188u"mm",  6.466u"mm",  6.647u"mm",  0.767u"mm", 0.677u"mm", 0.180u"mm"))
push!(SCREWS, (:M9,            9u"mm",   1.25u"mm", 8.188u"mm",  7.466u"mm",  7.647u"mm",  0.767u"mm", 0.677u"mm", 0.180u"mm"))
push!(SCREWS, (:M10,           10u"mm",  1.5u"mm",  9.026u"mm",  8.160u"mm",  8.376u"mm",  0.920u"mm", 0.812u"mm", 0.217u"mm"))
push!(SCREWS, (:M11,           11u"mm",  1.5u"mm",  10.026u"mm", 9.160u"mm",  9.376u"mm",  0.920u"mm", 0.812u"mm", 0.217u"mm"))
push!(SCREWS, (:M12,           12u"mm",  1.75u"mm", 10.863u"mm", 9.853u"mm",  10.106u"mm", 1.074u"mm", 0.947u"mm", 0.253u"mm"))
push!(SCREWS, (:M14,           14u"mm",  2u"mm",    12.701u"mm", 11.546u"mm", 11.835u"mm", 1.227u"mm", 1.083u"mm", 0.289u"mm"))
push!(SCREWS, (:M16,           16u"mm",  2u"mm",    14.701u"mm", 13.546u"mm", 13.835u"mm", 1.227u"mm", 1.083u"mm", 0.289u"mm"))
push!(SCREWS, (:M18,           18u"mm",  2.5u"mm",  16.376u"mm", 14.933u"mm", 15.294u"mm", 1.534u"mm", 1.353u"mm", 0.361u"mm"))
push!(SCREWS, (:M20,           20u"mm",  2.5u"mm",  18.376u"mm", 16.933u"mm", 17.294u"mm", 1.534u"mm", 1.353u"mm", 0.361u"mm"))
push!(SCREWS, (:M22,           22u"mm",  2.5u"mm",  20.376u"mm", 18.933u"mm", 19.294u"mm", 1.534u"mm", 1.353u"mm", 0.361u"mm"))
push!(SCREWS, (:M24,           24u"mm",  3u"mm",    22.051u"mm", 20.319u"mm", 20.752u"mm", 1.840u"mm", 1.624u"mm", 0.433u"mm"))
push!(SCREWS, (:M27,           27u"mm",  3u"mm",    25.051u"mm", 23.319u"mm", 23.752u"mm", 1.840u"mm", 1.624u"mm", 0.433u"mm"))
push!(SCREWS, (:M30,           30u"mm",  3.5u"mm",  27.727u"mm", 25.706u"mm", 26.211u"mm", 2.147u"mm", 1.894u"mm", 0.505u"mm"))
push!(SCREWS, (:M33,           33u"mm",  3.5u"mm",  30.727u"mm", 28.706u"mm", 29.211u"mm", 2.147u"mm", 1.894u"mm", 0.505u"mm"))
push!(SCREWS, (:M36,           36u"mm",  4u"mm",    33.402u"mm", 31.093u"mm", 31.670u"mm", 2.454u"mm", 2.165u"mm", 0.577u"mm"))
push!(SCREWS, (:M39,           39u"mm",  4u"mm",    36.402u"mm", 34.093u"mm", 34.670u"mm", 2.454u"mm", 2.165u"mm", 0.577u"mm"))
push!(SCREWS, (:M42,           42u"mm",  4.5u"mm",  39.077u"mm", 36.479u"mm", 37.129u"mm", 2.760u"mm", 2.436u"mm", 0.650u"mm"))
push!(SCREWS, (:M45,           45u"mm",  4.5u"mm",  42.077u"mm", 39.479u"mm", 40.129u"mm", 2.760u"mm", 2.436u"mm", 0.650u"mm"))
push!(SCREWS, (:M48,           48u"mm",  5u"mm",    44.752u"mm", 41.866u"mm", 42.587u"mm", 3.067u"mm", 2.706u"mm", 0.722u"mm"))
push!(SCREWS, (:M52,           52u"mm",  5u"mm",    48.752u"mm", 45.866u"mm", 46.587u"mm", 3.067u"mm", 2.706u"mm", 0.722u"mm"))
push!(SCREWS, (:M56,           56u"mm",  5.5u"mm",  52.428u"mm", 49.252u"mm", 50.046u"mm", 3.374u"mm", 2.977u"mm", 0.794u"mm"))
push!(SCREWS, (:M60,           60u"mm",  5.5u"mm",  56.428u"mm", 53.252u"mm", 54.046u"mm", 3.374u"mm", 2.977u"mm", 0.794u"mm"))
push!(SCREWS, (:M64,           64u"mm",  6u"mm",    60.103u"mm", 56.639u"mm", 57.505u"mm", 3.681u"mm", 3.248u"mm", 0.866u"mm"))
push!(SCREWS, (:M68,           68u"mm",  6u"mm",    64.103u"mm", 60.639u"mm", 61.505u"mm", 3.681u"mm", 3.248u"mm", 0.866u"mm"))

macro uncScrew(name, D, p)
    quote
        uncScrewHelper($name, $D, $p)
    end
end
function uncScrewHelper(name, D, p)
    H = sqrt(3)/2*p
    D_min = D - 3*sqrt(3)/8*p
    D_avg = (D_min + D)/2
    push!(SCREWS,
          (name, D*u"inch", p*u"inch", D_avg*u"inch", D_min*u"inch",
           D_min*u"inch", H*u"inch", H*u"inch", 0u"mm")
         )
end
@uncScrew :UNC1                 0.0730  0.015625
@uncScrew :UNC2                 0.0860  0.017857
@uncScrew :UNC3                 0.0990  0.020833
@uncScrew :UNC4                 0.1120  0.025000
@uncScrew :UNC5                 0.1250  0.025000
@uncScrew :UNC6                 0.1380  0.031250
@uncScrew :UNC8                 0.1640  0.031250
@uncScrew :UNC10                0.1900  0.041667
@uncScrew :UNC12                0.2160  0.041667
@uncScrew Symbol("UNC1/4")      0.2500  0.050000
@uncScrew Symbol("UNC5/16")     0.3125  0.055556
@uncScrew Symbol("UNC3/8")      0.3750  0.062500
@uncScrew Symbol("UNC7/16")     0.4375  0.071428
@uncScrew Symbol("UNC1/2")      0.5000  0.076923
@uncScrew Symbol("UNC9/16")     0.5625  0.083333
@uncScrew Symbol("UNC5/8")      0.6250  0.090909
@uncScrew Symbol("UNC3/4")      0.7500  0.100000
@uncScrew Symbol("UNC7/8")      0.8750  0.111111
@uncScrew Symbol("UNC1/1")      1.0000  0.125000


# Plot recipe
@userplot ScrewPlot

@recipe function f(h::ScrewPlot)
    measured_x = length(h.args) >= 1 ? h.args[1] : nothing
    measured_y = length(h.args) >= 2 ? h.args[2] : nothing
    xguide := "D"
    yguide := "d"
    @series begin
        seriestype := :scatter
        primary := false
        seriescolor := startswith.(String.(SCREWS[!,:name]), "M")*1
        markersize := 3
        label := nothing
        SCREWS[!, :nominal_diameter], diagonal_length.(SCREWS[!, :name])
    end

    if !isnothing(measured_x)
        rows = sort(SCREWS, order(:nominal_diameter, by=t->abs2(t-measured_x)))
        xs = ustrip.(get(plotattributes, :xunit, u"mm"), rows[1:4, :nominal_diameter])
        push!(xs, ustrip(get(plotattributes, :xunit, u"mm"), measured_x))
        ys = ustrip.(get(plotattributes, :yunit, u"mm"), rows[1:4, :outer_minor])
        xlims := extrema(xs)
        xwiden := true
        if !isnothing(measured_y)
            push!(ys, ustrip(get(plotattributes, :yunit, u"mm"), measured_y))
            ylims := extrema(ys)
            ywiden := true
            @series begin
                seriestype := :scatter
                seriescolor := :red
                markersize := 5
                label := "Measured"
                [measured_x], [measured_y]
            end
        else
            ylims := extrema(ys)
            ywiden := true
            @series begin
                seriestype := :vline
                seriescolor := :red
                label := "Measured"
                [measured_x]
            end
        end
        @series begin
            seriestype := :scatter
            primary := true
            series_annotations := [(s, -45.0, "Computer Modern") for s in SCREWS[!, :name]]
            seriescolor := startswith.(String.(SCREWS[!,:name]), "M")*1
            label := nothing
            SCREWS[!, :nominal_diameter], SCREWS[!, :outer_minor]
        end
    end
end

"""
```julia
screwplot()
```

Plot all the screws in the register, minor diameter vs major. Above each point will also be
the diagonal diameter, i.e. the diameter as measured by a caliper between a point along the
thread and another half a turn later, with a smaller marker.

The major diameter of a measured screw can be supplied to zoom the ``x`` axis to the nearest
couple of suggestions, as well as mark this value in the plot.

The minor diameter can be supplied as a second argument and will be used to further pinpoint
your screw in the plot.

## Example

A screw is somewhat haphazardly measured to be ``9.8\\;\\mathrm{mm}`` in diameter. The user
runs

```julia
screwplot(9.8u"mm")
```

and sees that the closest alternatives are M10 and UNC⅜. To differentiate them, the user
measures the diagonal minor diameter to be ``8.0\\;\\mathrm{mm}``. Now

```julia
using ScrewDimensions, Plots, Unitful
screwplot(9.8u"mm", 8.0u"mm")
```

shows that the closest screw is indeed M10.
"""
function screwplot end

"""
```julia
diagonal_length(name)
```
Find the diameter of a screw, as measured between two consecutive threads, as one would with
calipers.
"""
function diagonal_length(name)
    screw = SCREWS[SCREWS.name .=== name,:][1,:]
    return sqrt((screw.pitch/2)^2 + screw.outer_minor^2)
end

end
