# --  createDominoSet (C)
#     Generate an image for each of 55 double-nine dominoes.
#     
#     Function generates a cell array of 55 matrices, each
#     representing the image of a domino tile from a set of
#     double-nine dominoes.  
#
#     The cell array is saved to an octave-compatible .mat 
#     file.  
#
#     If input C is set to 'w', then generate images of black 
#     tiles with white dots and save cell array of images to 
#     Data/Domino_Set_Images/dominoes_with_black_dots.mat
#
#        createDominoSet("w") 
#
#     If C is set to 'k', then generate a set of white domino
#     tiles with black dots and save cell array of images to 
#     Data/Domino_Set_Images/dominoes_with_white_dots.mat
#
#        createDominoSet("k") 
#
#    Author:
#    Kalyani Nagaraj
#    March 2021

function createDominoSet(dotcolor)
 
   pkg load image

   # Set tile dimensions
   width = 10;
   offset = 0.5;
   height = 2*width + offset;

   # Set dot dimensions and color
   dotradius = 1;
   if dotcolor == 'w'
      colr = "white";
      clr = [1 1 1];
   elseif dotcolor == 'k'
      colr = "black";
      clr = [0 0 0];
   end

   # Define an empty cell array that will store images of all 55
   # dominoes
   c = cell(55,1);
                 
   ctr = 0;
   for m = 0:9
      for n = m:9
         printf("m=%d n=%d\n", m,n);

         # Draw rectangular tile:
         # ----------------------

         anchor = [0 0];
         vertices = [anchor(1)         anchor(2);
                     anchor(1)+width   anchor(2);
                     anchor(1)+width   anchor(2)+height;
                     anchor(1)         anchor(2)+height];
 
         # Fill make the domino a solid black domino
         figure
         fill (vertices(:,1), vertices(:,2), 1 .- clr, 'edgecolor', 1 .- clr);  
                                  # black dots on a white tile, or
                                  # white dots on a black tile
  
         # Display second digit n in lower square:                                            
         # ---------------------------------------
         dots = getDotLocations(n);
         dotCenters = getDotCenters(anchor, width);
   
         if (length(dots) > 0) # display dots only if n > 0
            for d = 1:length(dots)
               rectangle('Position', [(dotCenters(dots(d),:) .- dotradius) 2*dotradius 2*dotradius], 'Curvature', 1, 'EdgeColor', clr, 'FaceColor', clr)
               axis([0 (anchor(1)+width) 0 (anchor(2)+height)])
               axis equal
               axis off
            end
         end


         # Display first digit m in upper square:
         # --------------------------------------
         dots = getDotLocations(m);
         anchor = [anchor(1) anchor(2)+width+offset];
         dotCenters   = getDotCenters(anchor, width);
   
         if (length(dots) > 0) # display dots only if m > 0
            for d=1:length(dots)
               rectangle('Position', [(dotCenters(dots(d),:) .- dotradius) 2*dotradius 2*dotradius], 'Curvature', 1, 'EdgeColor', clr, 'FaceColor', clr)
               axis([0 (anchor(1)+width) 0 (anchor(2)+height)])
               axis equal
               axis off
            end
        end

        # Save image to a cell array:
        # ---------------------------
        anchor = [0 0];
        axis([0 (anchor(1)+width) 0 (anchor(2)+height)])
        axis equal   # x and y are one same scale
        axis off     # does not print axis
        axis tight   # fixes axes to the limits of the data
        axis manual  # fixes current axes limits

        #filename = strcat("im_", num2str(m), num2str(n));
        #print (filename, "-deps");

        # Convert figure to matrix form and store in cell array:
        # ------------------------------------------------------
        ctr += 1;
        F = getframe(gca); # `F` is struct with two fields: `cdata` and `colormap`
                           # use gca, and not gcf, as the latter will capture entire figure
                           # By saving image data in matrix form, vector graphics are converted 
                           # to pixel structure
        c(ctr, 1) = rgb2gray(frame2im(F)); 
        #close
        #clf

     end
  end
  
  # Save images to file:
  # --------------------
  save("-V7", strcat("../../Data/Domino_Set_Images/dominoes_with_", colr, "_dots_V7.mat"),  "c");  # V7 is Julia compatile when used with package MAT
  close all

end


function dots = getDotLocations(digit)
   
   if (digit == 1)
      dots = [5]; 
   elseif (digit == 2)
      dots = [3;7];
   elseif (digit == 3)
      dots = [3;5;7];
   elseif (digit == 4)
      dots = [1;3;7;9];
   elseif (digit == 5)
      dots = [1;3;5;7;9];
   elseif (digit == 6)
      dots = [1;3;4;6;7;9];
   elseif (digit == 7)
      dots = [1;3;4;5;6;7;9];
   elseif (digit == 8)
      dots = [1;2;3;4;6;7;8;9];
   elseif (digit == 9)
      dots = [1;2;3;4;5;6;7;8;9];
   else
      dots = [];
   endif

   return;

end



function dotCenters = getDotCenters(anchor, width)
                                                                      #     _________
                                                                      #    |         |
   dotCenters =   [(anchor(1) + width/5)   (anchor(2) + 4*width/5);   # 1  |  1 2 3  |
                   (anchor(1) + width/2)   (anchor(2) + 4*width/5);   # 2  |  4 5 6  |
                   (anchor(1) + 4*width/5) (anchor(2) + 4*width/5);   # 3  |  7 8 9  |
                   (anchor(1) + width/5)   (anchor(2) + width/2);     # 4  |_________|
                   (anchor(1) + width/2)   (anchor(2) + width/2);     # 5
                   (anchor(1) + 4*width/5) (anchor(2) + width/2);     # 6
                   (anchor(1) + width/5)   (anchor(2) + width/5);     # 7
                   (anchor(1) + width/2)   (anchor(2) + width/5);     # 8
                   (anchor(1) + 4*width/5) (anchor(2) + width/5)      # 9
                  ];
   return;

end