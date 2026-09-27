#include <malloc.h>

/* Deklarasi manual karena header Termux tidak expose mallopt */
extern int mallopt(int param, int value);

__attribute__((constructor))
static void disable_heap_tagging(void) {
    mallopt(M_BIONIC_SET_HEAP_TAGGING_LEVEL, M_HEAP_TAGGING_LEVEL_NONE);
}
