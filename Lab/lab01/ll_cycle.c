#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    if (head == NULL) {
        return 0;                    // 空表无环
    }
    node *tortoise = head;
    node *hare = head;
    while (hare != NULL && hare->next != NULL) {
        tortoise = tortoise->next;   // 走 1 步
        hare = hare->next->next;     // 走 2 步
        if (tortoise == hare) {
            return 1;                // 相遇 → 有环
        }
    }
    return 0;                        // hare 走到 null → 无环
}