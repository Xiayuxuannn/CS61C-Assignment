/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
	Color *color = malloc(sizeof(Color));
	if ((image->image[row][col].B & 0x1) == 1){
		color->G = 255;
		color->B = 255;
		color->R = 255;
	}
	else{
		color->G = 0;
		color->B = 0;
		color->R = 0;	
	}
	return color;
}

//Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
{
	Image *i1 = malloc(sizeof(Image));
	i1->rows = image->rows;
	i1->cols = image->cols;
	i1->image = malloc(i1->rows * sizeof(Color*));
	for (uint32_t i = 0; i < i1->rows; i++){
		i1->image[i] = malloc(i1->cols * sizeof(Color));
		for (uint32_t j = 0; j < i1->cols; j++){
			Color *c = evaluateOnePixel(image, i, j);
			i1->image[i][j] = *c;
			free(c);
		}
	}
	return i1;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image, 
where each pixel is black if the LSB of the B channel is 0, 
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv)
{
	if (argc != 2) {
		printf("usage: %s <filename>\n", argv[0]);
		return -1;
	}
	Image *Simage = readData(argv[1]);
	if (Simage == NULL) {
		return -1;
	}
	Image *Xsimage = steganography(Simage);
	writeData(Xsimage);
	freeImage(Simage);
	freeImage(Xsimage);
	return 0;
}
