@doc raw"""
    dominoes(imgname, colr, constrnt)

Approximate a grayscale image with complete sets of double-nine dominoes.

# Resources
Watch Bob Bosch of Oberlin College talk at Google about domino mosaics, and his interpretation of this art form as an integer program.
https://www.youtube.com/watch?v=g3CiVrN-BnY

IP modeling details can be found in this article.
http://www.optimization-online.org/DB_FILE/2003/09/722.pdf

# Examples
```julia-repl
julia> include("ModuleDominoes.jl")
julia> using .Dominoes
julia> createMosaic("Frankenstein", "white", "constrained")
```

# Author
Kalyani Nagaraj
March 2021
"""
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