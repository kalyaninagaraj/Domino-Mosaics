# -- preprocessImage(fname)
#
#    Produce a 0-9 grayscale, compressed version of image. 
#
#    Trim .jpg image fname located in DominoArt/Data/TargetImages
#    to fit s complete sets of dominoes, where s is obtained from 
#    user.  Next, convert image to grayscale, and then compress and 
#    rerescale pixel values on a 0-9 scale.  Save matrix representation 
#    of image as a text file in DominoArt/Data/Compressed_Images. 
#
#    For example, 
#
#       preprocessImage("Frankenstein")
#
#    produces a 0-9 grayscale, compressed version of the image 
#    DominoArt/Data/Target_Images/Frankenstein.jpg that is saved to
#    DominoArt/Data/Compressed_Images/Frankenstein.txt .
#    
#
#    Author:
#    Kalyani Nagaraj
#    March 2021

function preprocessImage(image_name)

   pkg load image

   # I. READ IMAGE FROM FILE, CONVERT RGB TO GRAYSCALE:
   # --------------------------------------------------
   I = imread(strcat("../../Data/Target_Images/", image_name, ".jpg"));
   if size(size(I),2) > 2 # if I is a 3-dimensional array
      I = rgb2gray (I);
   end


   # II. SATURATE IMAGE: 
   # -------------------
   ## Saturate based on mean and std deviation of pixel values
   #Idouble = im2double(I);  
   #n = 1;
   #avg = mean2(Idouble)
   #sigma = std2(Idouble)
   #K = imadjust(I,[avg-n*sigma avg+n*sigma], []);
   
   K = imadjust(I,[0.08 0.6], []);

   #K = I; 
   #imwrite(K, strcat("../../Data/Compressed_Images/", image_name, "_saturated.png"))


   # III. MANUALLY ENTER DIMENSIONS OF THE DOMINO POTRAIT:
   # -----------------------------------------------------
   printf("Input image is of size %d X %d\n", size(K));
   m = input("Enter number of rows of squares: ");    # m = 44; # number of rows
   n = input("Enter number of columns of squares: "); # n = 30; # number of columns
   k = input("Enter size of each square: ");          # k = 26; # size of each cell 
   

   # IV. COMPRESS IMAGE BY CHOPPING INTO SMALL SQUARES AND 
   #     FINDING EACH SQUARE'S MEAN/MEDIAN PIXEL VALUE:
   # -----------------------------------------------------
   L = zeros(k,k,m*n);
   P = zeros(m,n);
   for i = 1:m # i counts rows
      for j = 1:n # j counts columns
         L(:,:,m*(i-1)+j) = K( (i-1)*k+1:i*k, (j-1)*k+1:j*k ); 
         P(i,j) = mean( reshape(L(:,:,m*(i-1)+j), [], 1) );
      end
   end

   # V. RESCALE COMPRESSED IMAGE ON A 0-9 SCALE:
   # -------------------------------------------
   PP = P./256;
   PP = (floor(PP.*10))./10;
   imshow(PP)
   im = round(PP .* 10);     
    
   # VI. SAVE COMPRESSED AND SCALED IMAGE TO FILE:
   # ---------------------------------------------
   dlmwrite(strcat("../../Data/Compressed_Images/", image_name, ".txt"),  im, " ")

end
