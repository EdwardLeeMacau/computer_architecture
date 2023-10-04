/**
 * Solve T(n) = 2T(n - 1) + T(n - 2)
 */

#include <stdio.h>
#include <stdlib.h>

void help(char *prog)
{
    printf("Usage: %s <n>\n", prog);
    exit(1);
}

int main(int argc, char *argv[])
{
    if (argc != 2)
        help(argv[0]);

    const int n = atoi(argv[1]);
    int *T = (int *)malloc(sizeof(int) * (n + 1));

    T[0] = 0; T[1] = 1;
    for (int i = 2; i <= n; i++)
        T[i] = 2 * T[i - 1] + T[i - 2];

    printf("T(%d) = %d\n", n, T[n]);
    free(T);

    return 0;
}