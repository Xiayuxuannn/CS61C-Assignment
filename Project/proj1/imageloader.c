/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
	FILE *fp = fopen(filename, "r");
	if (fp == NULL) return NULL;
	char model[3] = {'P'};
	uint32_t cols, rows, maxVal = 0;
	fscanf(fp, "%s %u %u %u", model, &cols, &rows, &maxVal);
	Image *image = malloc(sizeof(Image));
	image->rows = rows;
	image->cols = cols;
	image->image = (Color **)malloc(rows * sizeof(Color*));
	for (uint32_t i = 0; i < rows; i++){
		image->image[i] = (Color *)malloc(cols * sizeof(Color));
		for (uint32_t j = 0; j < cols; j++){
			fscanf(fp, "%hhu %hhu %hhu", 
				  &image->image[i][j].R,
				  &image->image[i][j].G,
				  &image->image[i][j].B);
		}
	}
	fclose(fp);
	return image;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	uint32_t cols, rows = 0;
	cols = image->cols;
	rows = image->rows;
	printf("P3\n");
	printf("%u %u\n" ,cols, rows);
	printf("255\n");
	for (uint32_t i = 0; i < rows; i++){
		for (uint32_t j = 0; j < cols; j++){
			printf("%3hhu %3hhu %3hhu",
	       		  image->image[i][j].R,
	       		  image->image[i][j].G,
	       		  image->image[i][j].B);
			if (j != cols - 1){
				printf("   ");
			}
			else printf("\n");
		}
	}
}

//Frees an image
void freeImage(Image *image)
{
	for (uint32_t i = 0; i < image->rows; i++) {
		free(image->image[i]);
	}
	free(image->image);
	free(image);
}