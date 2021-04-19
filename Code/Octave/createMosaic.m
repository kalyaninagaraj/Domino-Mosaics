# -- createMosaic (fname, colr)
#    Generate the image of a domino mosaic from the 
#    optimization output file fname.txt.  
#
#    The input colr determines the color of the domino 
#    tiles and dots. 
#
#    For example, to generate a mosaic of white dominoes 
#    with black dots from the optimization output file 
#    Frankenstein_black.txt, 
# 
#       createMosaic("Frankenstein_black", "black")
# 
#    Similarly, to generate a mosaic of black tiles with 
#    white dots,
#
#       createMosaic("Frankenstein_white", "white")
#     
#    Note that the function requires domino images in
#    Data/Domino_Set_Images/dominoes_with_black_dots.mat (or
#    Data/Domino_Set_Images/dominoes_with_white_dots.mat,  
#    depending on the input argument colr) as input. 
#
#    The resulting mosaic image is saved as a .png file 
#    named fname under DominoArt/Data/Mosaic_Images. 
#
#    Author:
#    Kalyani Nagaraj
#    March 2021

function createMosaic(image_name, dotcolr)

   # 1. LOAD 55 DOMINO IMAGES FROM FILE:
   # ------------------------------------
   load(strcat("../../Data/Domino_Set_Images/dominoes_with_", dotcolr, "_dots.mat"));
   # Make each matrix of size (332, 162)
   d = cell(55,1);
   for i = 1:55
      d{i} = c{i}(12:end,179:340);
   end
   [r c] = size(d{1});
   offset = r-2*c;

   # 2. READ SOLUTION INDICES FROM FILE:
   # -----------------------------------
   layout = dlmread(strcat("../../Data/Optimization_Output/Indices/", image_name, ".txt"), ' ', 0, 0);
   rowcol = layout(1, 1:2);
   R = rowcol(1); # Number of rows
   C = rowcol(2); # Number of columns
   layout = layout(2:end,:);


   # 3. FOR EACH ENTRY IN LAYOUT, WRITE DOMINO IMAGE TO MATRIX I:
   # ------------------------------------------------------------
   if strcmp(dotcolr, "white") == 1
      I = 255*ones(R*(offset + c), C*(offset + c));
   elseif strcmp(dotcolr, "black") == 1
      I = zeros(R*(offset + c), C*(offset + c));
   end

   for domino = 1:size(layout,1)

      m = layout(domino, 1);
      n = layout(domino, 2);
      o = layout(domino, 3);
      i = layout(domino, 4);
      j = layout(domino, 5);

      # 4. Get domino cell number:
      # --------------------------
      k = 10*m + n - sum(1:m) + 1;

      if o == 1
         # place domino as is at location (i,j)
         dd = d{k};

      elseif o == 2
         # swap m and n
         dd = [d{k}(r/2 + 1:end, :); d{k}(1:r/2, :)];

      elseif o == 3
         # rotate counterclockwise by 90 degrees
         dd = [d{k}'(end:-1:c/2+1, :); d{k}'(c/2:-1:1, :)];

      elseif o == 4
         # first swap m and n, then rotate by 90 degrees
         dd = [d{k}(r/2 + 1:end, :); d{k}(1:r/2, :)];
         dd = [dd'(end:-1:c/2+1, :); dd'(c/2:-1:1, :)];

      end
   
      I((i-1)*(c+offset)+1:(i-1)*(c+offset)+size(dd,1) , (j-1)*(c+offset)+1:(j-1)*(c+offset)+size(dd,2)) = dd;
   
   end

   # 5. Save image to file:
   # ----------------------
   imshow(I)
   imwrite(I, strcat("../../Data/Mosaic_Images/", image_name, ".png"));


end
