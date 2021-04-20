# Domino Mosaics a-la Robert Bosch and Ken Knowlton
<a href="https://github.com/kalyaninagaraj/Domino-Mosaics/blob/main/Data/Target_Images/CE.jpg"><img src="/Data/Target_Images/CE.jpg?raw=true" width="215px"></a>&nbsp;&nbsp; <a href="https://github.com/kalyaninagaraj/Domino-Mosaics/blob/main/Data/Mosaic_Images/CE_white.png"><img src="/Data/Mosaic_Images/CE_white.png?raw=true" width="200px"></a>&nbsp;&nbsp; <a href="https://github.com/kalyaninagaraj/Domino-Mosaics/blob/main/Data/Mosaic_Images/CE_black.png"><img src="/Data/Mosaic_Images/CE_black.png?raw=true" width="200px"></a>

Two Clint Eastwood mosaics, each in 12 complete sets of double-nine dominoes; the first with white dots on black tiles, and the other with black dots on white tiles. 


## About
This repository is home to Octave and Julia code that approximates a grayscale image with complete sets of [double-nine dominoes](http://www.domino-games.com/domino-rules/double-nine.html). 

To know more, watch Bob Bosch of Oberlin College [talk at Google](https://www.youtube.com/watch?v=g3CiVrN-BnY) about domino mosaics, and his interpretation of this form of art as an integer program.

## Instructions
1. First, create a library of images for each domino in a set of 55 double-nine dominoes. 

CODE: `Code/Octave/createDominoSet.m`

TO RUN CODE: 
1. Open Terminal and change current directory to `Code/Octave/`. 
2. Open Octave by entering `octave` at the terminal. 
3. To generate images of black tiles with white dots, run the octave code by entering 
`createDominoSet('white')`. To generate a images of white dominoes with black dots, set input argument to 'black' instead of 'white'.  

INPUT: Color of dots (and tiles) 

OUTPUT: A MATLAB (and Octave) compatible file `.mat` in `Data/Domino_Set_Images`.  

Run code /once/ for each tile color. The images (more precisely, the cell array of matrices) are saved to `Data/Domino_Set_Images/dominoes_with_black_dots_V7.mat` and `Data/Domino_Set_Images/dominoes_with_white_dots_V7.mat`. 


2. Next, choose a target image. Crop the image to accomodate multiple complete sets of dominoes. The exact number will be determined manually depending on the cropped image's dimensions. Now run the code to perform some image processing and to obtain a compressed, grayscale version of the image in the form of a matrix of integers. 

CODE: `Code/Octave/preprocessImage.m`

TO RUN CODE: 
  1. Open Terminal and change current directory to `Octave_scripts`. 
  2. Open Octave by entering `octave`. 
  3. Run code by entering `preprocessImage ('CE')`. 

INPUT: 
  1. `CE.jpg` is the name of target image saved in `Data/Target_Images/`.
  2. The code will ask user to manually enter dimensions `m` and `n` of the domino portrait. These dimensions are such that `mn = 110s`, where `s` is the number of complete sets used in the image. Also, manually enter `k`, the size of each cell, such that `mk` equals the number of rows of pixels and `nk` equals the number of columns of pixels in the trimmed image. For this example, set `m` to , `n` to , and `k` to . 

OUTPUT: A scaled and compressed image file `Data/Compressed_Images/CE.txt` in the form of a matrix of integers ranging from 0 and 9. 


3. And finally, approximate a greyscale image with s sets of double-nine dominoes by solving a binary integer program. 

CODE: `Code/Julia/ModuleDominoes.jl`

TO RUN CODE: 1. Open Terminal and change current directory to `Code/Julia/`. 
             2. Open Julia by entering `julia` at the command line. 
             3. Enter the following commands. 
```
julia> include("ModuleDominoes.jl")
julia> using .Dominoes
julia> dominoes("CE", "white", "constrained")
```
INPUT: The input parameter `constrained` indicates that complete sets of dominoes will be used to generate the final mosaic. Setting this last parameter to `unconstrained` indicates to the code that the mosaic can be built from an unending supply of dominoes, which naturally does not make for an interesting optimization problem. 

OUTPUT: The second input parameter determines the color of the dots on the dominoes. For the above example, the code will generate `Data/Mosaic_Images/CE_white_constrained.png`. 

## Code Credits
[@kalyaninagaraj](https://github.com/kalyaninagaraj)

## References
1. IP modeling details can be found in ["Constructing Domino Portraits" in Tribute to a Mathemagician"](http://www.optimization-online.org/DB_FILE/2003/09/722.pdf). 
2. For Bob Bosch's idea of domino steganography see [here](http://archive.bridgesmathart.org/2020/bridges2020-199.pdf). 


