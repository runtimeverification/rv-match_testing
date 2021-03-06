#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    :
}

_download() {
    mkdir bogosort/
    cd bogosort/
    touch bogosort.c
    echo '
    /*
     * C Program to Implement BogoSort in an Integer Array
     */
    #include <stdio.h>
    #include <stdlib.h>
     
    #define size 7
    /* Function Prototypes */
     
    int is_sorted(int *, int);
    void shuffle(int *, int); 
    void bogosort(int *, int);
     
    int main()
    {
        int numbers[size];
        int i;
     
        printf("Enter the elements of array:");
        for (i = 0; i < size;i++)
        {
            scanf("%d", &numbers[i]);
        }
        bogosort(numbers, size);
        printf("The array after sorting is:");
        for (i = 0;i < size;i++)
        {
            printf("%d\n", numbers[i]);
        }
        printf("\n");
    }
     
    /* Code to check if the array is sorted or not */
    int is_sorted(int *a, int n)
    {
        while (--n >= 1)
        {
            if (a[n] < a[n - 1])
            {
                return 0;
            }
        }
          return 1;
    }
     
    /* Code to shuffle the array elements */
    void shuffle(int *a, int n)
    {
        int i, t, temp;
        for (i = 0;i < n;i++)
        {
            t = a[i];
            temp = rand() % n;    /* Shuffles the given array using Random function */
            a[i] = a[temp];
            a[temp] = t;
        }
    }
     
    /* Code to check if the array is sorted or not and if not sorted calls the shuffle function to shuffle the array elements */
    void bogosort(int *a, int n)
    {
        while (!is_sorted(a, n))
        {
            shuffle(a, n);
        }
    }
' > bogosort.c
}

_build() {
    cd bogosort/ ; results[0]="$?" ; postup 0
    $compiler bogosort.c ; results[1]="$?" ; postup 1
}

_test() {
    cd bogosort/
    name[0]="basic test"
    echo "9 43 27 12 5 9 3" | ./a.out |& tee rv_out_0.txt ; results[0]="$?" ; process_config 0
}

init
