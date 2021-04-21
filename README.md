# Domino Mosaics, \`a la Robert Bosch and Ken Knowlton


## About
This repository is home to optimization code in Julia that approximates a grayscale image with an image formed by complete sets of [double-nine dominoes](http://www.domino-games.com/domino-rules/double-nine.html). 

<!-- <a href="https://github.com/kalyaninagaraj/Domino-Mosaics/blob/main/Data/Target_Images/CE.jpg"><img src="/Data/Target_Images/CE.jpg?raw=true" width="255px"></a>&nbsp;&nbsp; <a href="https://github.com/kalyaninagaraj/Domino-Mosaics/blob/main/Data/Mosaic_Images/CE_white.png"><img src="/Data/Mosaic_Images/CE_white.png?raw=true" width="240px"></a>&nbsp;&nbsp; <a href="https://github.com/kalyaninagaraj/Domino-Mosaics/blob/main/Data/Mosaic_Images/CE_black.png"><img src="/Data/Mosaic_Images/CE_black.png?raw=true" width="240px"></a> -->

<a href="https://github.com/kalyaninagaraj/Domino-Mosaics/blob/main/Data/Target_Images/HM.jpg"><img src="/Data/Target_Images/HM.jpg?raw=true" width="250px"></a>&nbsp;&nbsp; <a href="https://github.com/kalyaninagaraj/Domino-Mosaics/blob/main/Data/Mosaic_Images/HM_white_constrained.png"><img src="/Data/Mosaic_Images/HM_white_constrained.png?raw=true" width="250px"></a>&nbsp;&nbsp; <a href="https://github.com/kalyaninagaraj/Domino-Mosaics/blob/main/Data/Mosaic_Images/HM_black_constrained.png"><img src="/Data/Mosaic_Images/HM_black_constrained.png?raw=true" width="250px"></a>

<!-- For example, the two mosaics (middle and right image), each in 12 complete sets of double-nine dominoes, are a pointillistic representation of Clint Eastwood's still (image on left) from the movie "Where Eagles Dare". -->

The image on the left is of a young [Hank Marvin](https://en.wikipedia.org/wiki/Hank_Marvin) from his days with [The Shadows](https://en.wikipedia.org/wiki/The_Shadows). The two mosaics to its right (zoom in to see the tiles), each in 12 complete sets of double-nine dominoes, are a pointillistic representation of this black-and-white photo of Hank. 

To know more about domino mosaics, and their interpretation as the solution to an integer program, watch Robert Bosch of Oberlin College giving this [talk at Google](https://www.youtube.com/watch?v=g3CiVrN-BnY). 

## Instructions
1. First, create a library of images for each domino in a set of 55 double-nine dominoes. 

  - CODE: `Code/Octave/createDominoSet.m`

  - TO RUN CODE: 
      1. Open Terminal and change current directory to `Code/Octave/`. 
      2. Open Octave by entering `octave` at the terminal. 
      3. To generate images of black tiles with white dots, run the octave code by entering `createDominoSet('white')`. To generate a images of white dominoes with black dots, set input argument to `'black'` instead of `'white'`.  

   - OUTPUT: A MATLAB (and Octave) compatible file `.mat` in `Data/Domino_Set_Images`.  

   - Run code _once_ for each tile color. The images (more precisely, the cell array of matrices) are saved to `Data/Domino_Set_Images/dominoes_with_black_dots_V7.mat` and `Data/Domino_Set_Images/dominoes_with_white_dots_V7.mat`. 


2. Next, choose a target image. Crop the image to accomodate multiple complete sets of dominoes. The exact number will be determined manually depending on the cropped image's dimensions. Now run the code to perform some image processing and to obtain a compressed, grayscale version of the image in the form of a matrix of integers. 

   - CODE: `Code/Octave/preprocessImage.m`

   - TO RUN CODE: 
      1. Open Terminal and change current directory to `Octave_scripts`. 
      2. Open Octave by entering `octave`. 
      3. Run code by entering `preprocessImage ('CE')`. 

   - INPUT: 
      1. Input parameter `'CE'` directs the code to look for the target image `CE.jpg` in `Data/Target_Images/`.
      2. The code will ask user to manually enter dimensions `m` and `n` of the domino portrait. These dimensions are such that `mn = 110s`, where `s` is the number of complete sets used in the image. Also, manually enter `k`, the size of each cell, such that `mk` equals the number of rows of pixels and `nk` equals the number of columns of pixels in the trimmed image. For this example, set `m` to 44, `n` to 30, and `k` to 26. 

   - OUTPUT: A scaled and compressed image file `Data/Compressed_Images/CE.txt` in the form of a matrix of integers ranging from 0 and 9. 


3. And finally, approximate a greyscale image with s sets of double-nine dominoes by solving a binary integer program. 

   - CODE: `Code/Julia/ModuleDominoes.jl`

   - TO RUN CODE: 
       1. Open Terminal and change current directory to `Code/Julia/`. 
       2. Open Julia by entering `julia` at the command line. 
       3. Enter the following commands. 

       ```
       julia> include("ModuleDominoes.jl")
       julia> using .Dominoes
       julia> dominoes("CE", "white", "constrained")
       ```
   - INPUT: The input parameter `"constrained"` indicates that complete sets of dominoes will be used to generate the final mosaic. Setting this last parameter to `"unconstrained"` indicates to the code that the mosaic can be built from an unending supply of dominoes, which naturally does not make for an interesting optimization problem. 

   - OUTPUT: The second input parameter determines the color of the dots on the dominoes. For the above example, the code will generate `Data/Mosaic_Images/CE_white_constrained.png`. 

## Code Credits
[@kalyaninagaraj](https://github.com/kalyaninagaraj)

## Photo Credit
The image of Hank Marvin is cropped from a [group photo](https://commons.wikimedia.org/wiki/File:Cliff_Richard_aankomst_met_zijn_Shadows,_Bestanddeelnr_913-7397.jpg) of The Shadows, which appears in the public domain. 

## References
1. This [book review](https://blogs.scientificamerican.com/roots-of-unity/the-mathematics-of-opt-art/) in the Scientific American of Bob Bosch's book [Opt Art](https://press.princeton.edu/books/hardcover/9780691164069/opt-art) is a great introduction to the author's unique take on _pointillism-via-optimization_. 
2. Details on how to model the integer program  can be found in the article ["Constructing Domino Portraits"](http://www.optimization-online.org/DB_FILE/2003/09/722.pdf) in ["Tribute to a Mathemagician"](https://www.routledge.com/Tribute-to-a-Mathemagician/Cipra-Demaine-Demaine-Rodgers/p/book/9780367446536). 
3. Check out all of [Bob Bosch's Mathematical Art] (http://www.dominoartwork.com/) and [Ken Knowlton's Mosaics](http://www.kenknowlton.com/)
