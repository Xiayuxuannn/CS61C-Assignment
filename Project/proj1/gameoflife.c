/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	int rows = (int)image->rows;
	int cols = (int)image->cols;
	Color *color = malloc(sizeof(Color));
	uint8_t newR = 0, newG = 0, newB = 0;

	for (int b = 0; b < 8; b++) {                  // 每一位独立处理
		int aliveR = (image->image[row][col].R >> b) & 1;
		int aliveG = (image->image[row][col].G >> b) & 1;
		int aliveB = (image->image[row][col].B >> b) & 1;
		int kR = 0, kG = 0, kB = 0;                // 活邻居数
		for (int dr = -1; dr <= 1; dr++) {
			for (int dc = -1; dc <= 1; dc++) {
				if (dr == 0 && dc == 0) continue;
				int nr = (row + dr + rows) % rows;
				int nc = (col + dc + cols) % cols;
				kR += (image->image[nr][nc].R >> b) & 1;
				kG += (image->image[nr][nc].G >> b) & 1;
				kB += (image->image[nr][nc].B >> b) & 1;
			}
		}

		newR |= ((rule >> (aliveR ? 9 + kR : kR)) & 1) << b;
		newG |= ((rule >> (aliveG ? 9 + kG : kG)) & 1) << b;
		newB |= ((rule >> (aliveB ? 9 + kB : kB)) & 1) << b;

		color->R = newR;
		color->G = newG;
		color->B = newB;
	}
	return color;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	Image *i1 = malloc(sizeof(Image));
	i1->rows = image->rows;
	i1->cols = image->cols;
	i1->image = malloc(i1->rows * sizeof(Color*));
	for (uint32_t i = 0; i < i1->rows; i++){
		i1->image[i] = malloc(i1->cols * sizeof(Color));
		for (uint32_t j = 0; j < i1->cols; j++){
			Color *c = evaluateOneCell(image, i, j, rule);
			i1->image[i][j] = *c;
			free(c);
		}
	}
	return i1;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	if (argc != 3) {
		printf("usage: ./gameOfLife filename rule\n");
		printf("filename is an ASCII PPM file (type P3) with maximum value 255.\n");
		printf("rule is a hex number beginning with 0x; Life is 0x1808.\n");
		return -1;
	}
	Image *Flife = readData(argv[1]);
	if (Flife == NULL) {
		return -1;
	}
	uint32_t rule = (uint32_t)strtol(argv[2], NULL, 16);
	Image *Nxtlife = life(Flife, rule);
	writeData(Nxtlife);
	freeImage(Flife);
	freeImage(Nxtlife);
	return 0;
}
