#include <stdio.h>
#include <stdlib.h>

void help(char *prog)
{
    printf(
        "Usage:\n"
        "  %s\n");
    exit(1);
}

int main(int argc, char *argv[])
{
    if (argc != 2)
        help(argv[0]);

    scanf("%d", &n);
    int *T = (int *)malloc(sizeof(int) * (n));
    for (int i = 0; i < n; i++)
        scanf("%d", T + i);

    for (int i = 0; i < n; i++)
        printf("%d ", T[i]);
    printf("\n");

    free(T);
    return 0;
}