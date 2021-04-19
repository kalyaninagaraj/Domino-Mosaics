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
julia> dominoes("Frankenstein", "white", "constrained")
```

# Author
Kalyani Nagaraj
March 2021
"""
function dominoes(imgname, colr, constrnt)

   ## READ DATA
   g = readdlm("../../Data/Compressed_Images/" * imgname * ".txt", ' ', Int)

   if cmp(colr, "black") == 0 # Flip the scale, i.e., map 0-9 to 9-0, 
      g = 9 .- g;                 # if final image is to be generated 
   end                           # from white tiles with black dots.

   R = size(g,1)         # Number of rows of squares in the domino image
   C = size(g,2)         # Number of columns of squares in the domino image
   s = Int(R*C/110)      # Number of sets of dominoes


   ## MODEL THE OPTIMIZATION PROBLEM
   # I. Define a model and the optimizer it will use
   dominoes = Model(GLPK.Optimizer)
   # set_optimizer_attribute(dominoes, "msg_lev", GLPK.GLP_MSG_ON)
 

   # II. Create binary variables
   # x_mnoij = 1 if domino (m,n), where m<=n,  has oriented o starting in cell
   # (i,j)
   # number of variables = 55*4*R*C
   @variable(dominoes, x[m=0:9, n=m:9, o=1:4, i=1:R, j=1:C], Bin);
   # undo_relax = relax_integrality(dominoes); # Returns a function that can be 
                                               # called without any arguments to 
                                               # restore the original model. 
                                               # The behavior of this function is 
                                               # undefined if additional changes are 
                                               # made to the affected variables in 
                                               # the meantime.


   # III. Define the objective function
   @objective(dominoes, Min, sum(( (m-g[i,j])^2 + (n-g[i+1,j])^2 ) * x[m,n,1,i,j]  for m=0:9, n=m:9, i=1:R-1, j=1:C)
                           + sum(( (m-g[i+1,j])^2 + (n-g[i,j])^2 ) * x[m,n,2,i,j]  for m=0:9, n=m:9, i=1:R-1, j=1:C)
                           + sum(( (m-g[i,j])^2 + (n-g[i,j+1])^2 ) * x[m,n,3,i,j]  for m=0:9, n=m:9, i=1:R, j=1:C-1)
                           + sum(( (m-g[i,j+1])^2 + (n-g[i,j])^2 ) * x[m,n,4,i,j]  for m=0:9, n=m:9, i=1:R, j=1:C-1))

   # IV. Now, the constraints:
   # A. Type-1 constraint: Domino (m,n) can be used exactly s times, if using exactly s complete sets of double-none dominoes.
   if constrnt == "constrained"
      for m = 0:9, n = m:9   
         # 55 type-1 constraints    
         @constraint(dominoes, sum(x[m,n,o,i,j] for o=1:4, i=1:R, j=1:C) == s) 
      end
   elseif constrnt == "unconstrained"
      # a total of 55s domino tiles are used 
      @constraint(dominoes, sum(x[m,n,o,i,j] for m=0:9, n=m:9, o=1:4, i=1:R, j=1:C) == 55*s)
   end

   # B. Type-2 constraints: Each square in the image is covered by one domino
   # either placed horizontally or vertically

   # All but first row and first column:
   for i = 2:R, j = 2:C # a total of 110s type-2 constraints
      @constraint(dominoes, sum(x[m,m,1,i,j] for m=0:9) +
                            sum(x[m,m,1,i-1,j] for m=0:9) +
                            sum(x[m,m,3,i,j] for m=0:9) +
                            sum(x[m,m,3,i,j-1] for m=0:9) +

                            sum(x[m,n,1,i,j] for m=0:9, n=m+1:9) +
                            sum(x[m,n,2,i,j] for m=0:9, n=m+1:9) +
                            sum(x[m,n,1,i-1,j] for m=0:9, n=m+1:9) +
                            sum(x[m,n,2,i-1,j] for m=0:9, n=m+1:9) +

                            sum(x[m,n,3,i,j] for m=0:9, n=m+1:9) +
                            sum(x[m,n,4,i,j] for m=0:9, n=m+1:9) +
                            sum(x[m,n,3,i,j-1] for m=0:9, n=m+1:9) +
                            sum(x[m,n,4,i,j-1] for m=0:9, n=m+1:9) == 1)
   end


   # top row cells (i=1), all except top left cell
   for j = 2:C 
      # C-1 constraints
      @constraint(dominoes, sum(x[m,m,1,1,j] for m=0:9) +
                            sum(x[m,m,3,1,j] for m=0:9) +
                            sum(x[m,m,3,1,j-1] for m=0:9) +

                            sum(x[m,n,1,1,j] for m=0:9, n=m+1:9) +
                            sum(x[m,n,2,1,j] for m=0:9, n=m+1:9) +

                            sum(x[m,n,3,1,j] for m=0:9, n=m+1:9) +
                            sum(x[m,n,4,1,j] for m=0:9, n=m+1:9) +
                            sum(x[m,n,3,1,j-1] for m=0:9, n=m+1:9) +
                            sum(x[m,n,4,1,j-1] for m=0:9, n=m+1:9) == 1)
   end


   # first column (j=1), all except top left cell
   for i = 2:R 
      # R-1 constraints
      @constraint(dominoes, sum(x[m,m,1,i,1] for m=0:9) +
                            sum(x[m,m,1,i-1,1] for m=0:9) +
                            sum(x[m,m,3,i,1] for m=0:9) +

                            sum(x[m,n,1,i,1] for m=0:9, n=m+1:9) +
                            sum(x[m,n,2,i,1] for m=0:9, n=m+1:9) +
                            sum(x[m,n,1,i-1,1] for m=0:9, n=m+1:9) +
                            sum(x[m,n,2,i-1,1] for m=0:9, n=m+1:9) +

                            sum(x[m,n,3,i,1] for m=0:9, n=m+1:9) +
                            sum(x[m,n,4,i,1] for m=0:9, n=m+1:9) == 1)
   end


   # 1 constraint corresponding to top left cell
   @constraint(dominoes, sum(x[m,m,1,1,1] for m=0:9) +
                         sum(x[m,m,3,1,1] for m=0:9) +
 
                         sum(x[m,n,1,1,1] for m=0:9, n=m+1:9) +
                         sum(x[m,n,2,1,1] for m=0:9, n=m+1:9) + 

                         sum(x[m,n,3,1,1] for m=0:9, n=m+1:9) +
                         sum(x[m,n,4,1,1] for m=0:9, n=m+1:9) == 1)
   # print(dominoes)
	
   f = open("../../Data/Optimization_Output/Model_files/" * imgname * "_" * colr * "_" * constrnt * ".txt", "w")
   println("This optimization model has ", num_variables(dominoes), " variables, and ", 55 + R*C, " constraints.")
   
   print(f, dominoes)
   close(f)

   ## SOLVE THE OPTIMIZATION PROBLEM
   # V. And finally, solve problem
   optimize!(dominoes)
   if primal_status(dominoes) != MOI.FEASIBLE_POINT
      print("No feasible solution found!\n")
   else

      println("Feasible solution found after ", solve_time(dominoes), " seconds!")
      x_val = value.(x)
      println("Optimal objective value = ", objective_value(dominoes));
      println("Average difference in cell value = ", sqrt(objective_value(dominoes)/(110*s)));

      display(x_val)
      ## SAVE SOLUTION
      # Create a matrix to store the solution
      sol = zeros(Int,R,C)  # 9x9 matrix of integers
      for m=0:9, n=m:9, o=1:4, i=1:R, j=1:C
         # Integer programs are solved as a series of linear programs
         # so the values might not be precisely 0 and 1. We can just
         # round them to the nearest integer to make it easier
         if round(Int,x_val[m,n,o,i,j]) == 1
            if o == 1
               sol[i,j] = m
               sol[i+1,j] = n
            elseif o == 2
               sol[i,j] = n
               sol[i+1,j] = m
            elseif o == 3
               sol[i,j] = m
               sol[i,j+1] = n
            elseif o == 4
               sol[i,j] = n
               sol[i,j+1] = m
            end
         end
      end

      open("../../Data/Optimization_Output/Images/" * imgname * "_" * colr * "_" * constrnt * ".txt", "w") do io
          writedlm(io, sol, ' ')
      end
								

      opt_x_ind = [[m, n, o, i, j] for i=1:R for j=1:C for m=0:9 for n=m:9 for o=1:4 if round(Int, x_val[m,n,o,i,j]) == 1]
      opt_x_ind = reshape( collect(Iterators.flatten(opt_x_ind)), (5, :) )'
      open("../../Data/Optimization_Output/Indices/" * imgname * "_" * colr * "_" * constrnt * ".txt", "w") do io
         writedlm(io, [R C], ' ')
         writedlm(io, opt_x_ind, ' ')
      end

   end

end
