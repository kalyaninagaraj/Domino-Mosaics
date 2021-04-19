@doc raw"""
    createMosaic(indices, colr, constrnt)

Renders domino mosaic from optimization output

# Resources
Watch Bob Bosch of Oberlin College talk at Google about domino mosaics, and his interpretation of this art form as an integer program.
https://www.youtube.com/watch?v=g3CiVrN-BnY

IP modeling details can be found in this article.
http://www.optimization-online.org/DB_FILE/2003/09/722.pdf

# Examples
```julia-repl
julia> include("ModuleDominoes.jl")
julia> using .Dominoes
julia> createMosaic("Frankenstein", "black", "constrained")
```

# Author
Kalyani Nagaraj
March 2021
"""
function createMosaic(imgname, colr, constraint)


   # CALL OPTIMIZER:
   # ---------------
   dominoes(imgname, colr, constraint)
   imgname * "_" * colr * "_" * constraint
   
   # 1. LOAD 55 DOMINO IMAGES FROM FILE:
   # ------------------------------------
   file = matopen("../../Data/Domino_Set_Images/dominoes_with_" * colr * "_dots_V7.mat") # -V7 is compatible with Julia when used with package MAT 
   f = read(file, "c") # m is read as a array of 55 arrays, each of type UInt8
   d = Int64.(ones(332,162,55)) #Make each matrix of size (332, 162)
   for i = 1:55
      d[:,:,i] = Int64.(f[i][12:end,179:340])
   end
   r = size(d[:,:,1],1)
   c = size(d[:,:,1],2)
   offset = r-2*c
   

   # 2. READ SOLUTION INDICES FROM FILE:
   # -----------------------------------
   layout = readdlm("../../Data/Optimization_Output/Indices/" * imgname * "_" * colr * "_" * constraint * ".txt", ' ', Int, skipstart = 1)
   R = maximum(layout[:, 4])
   C = maximum(layout[:, 5])

   
   # 3. FOR EACH ENTRY IN LAYOUT, WRITE DOMINO IMAGE TO MATRIX I:
   # ------------------------------------------------------------
   if colr == "white"
      I = Int64.(255*ones(R*(offset + c), C*(offset + c)))
   elseif colr == "black"
      I = Int64.(zeros(R*(offset + c), C*(offset + c)))
   end


   for domino = 1:size(layout,1)

      m = layout[domino, 1]
      n = layout[domino, 2]
      o = layout[domino, 3]
      i = layout[domino, 4]
      j = layout[domino, 5]

      # 4. Get domino cell number:
      # --------------------------
      k = 10*m + n - sum(1:m) + 1

      if o == 1
         # place domino as is at location (i,j)
         dd = d[:,:,k];

      elseif o == 2
         # swap m and n
         dd = [d[Int64(r/2 + 1):end, :,k]; d[1:Int64(r/2), :, k]]

      elseif o == 3
         # rotate counterclockwise by 90 degrees
         # dd = [d{k}'(end:-1:c/2+1, :); d{k}'(c/2:-1:1, :)];
         dt = d[:,:,k]';  # transpose(d(k)) to get size(dt) = (c, r)
         dd = [dt[end:-1:Int64(c/2+1), :]; dt[Int64(c/2):-1:1, :]] # swap top and bottom half as mirror images

      elseif o == 4
         # first swap m and n, then rotate by 90 degrees
         # dd = [d{k}(r/2 + 1:end, :); d{k}(1:r/2, :)];
         # dd = [dd'(end:-1:c/2+1, :); dd'(c/2:-1:1, :)];
         dt = [d[Int64(r/2 + 1):end, :,k]; d[1:Int64(r/2), :, k]]'    # swap m and n, and perform a matrix transpose
         dd = [dt[end:-1:Int64(c/2+1), :]; dt[Int64(c/2):-1:1, :]]     # swap top and bottom half as mirror images

      end
   
      I[(i-1)*(c+offset)+1 : (i-1)*(c+offset)+size(dd,1) , (j-1)*(c+offset)+1 : (j-1)*(c+offset)+size(dd,2)] = dd;
   
   end

   # 5. Save image to file:
   # ----------------------
   I = colorview(Gray, I/256)
   save("../../Data/Mosaic_Images/" * imgname * "_" * colr * "_" * constraint * ".png", I) 

end