module Dominoes

using JuMP
using GLPK
using DelimitedFiles
using MAT	
using ImageView, Images, FileIO

include("dominoes.jl")
include("createMosaic.jl")

export createMosaic

end