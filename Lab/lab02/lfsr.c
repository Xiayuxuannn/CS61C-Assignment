#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    uint16_t feedback = (*reg & 0x1) ^ ((*reg >> 2) & 0x1) ^ ((*reg >> 3) & 0x1) ^ ((*reg >> 5) & 0x1);
    *reg = *reg >>1 | (feedback << 15);
}

