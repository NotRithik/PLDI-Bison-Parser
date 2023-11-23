void printInt(int n);
void printStr(char* str);
int binarySearch(int l, int r, int x);
void testLoops();

char* string = "Hello World!\t\r\n\"\'\\";

void testLoops() {
    int i;
    for (i = 0; i < 5; i = i + 1) {
        if (i % 2 == 0) {
            printStr("Even number: ");
            printInt(i);
        } else {
            printStr("Odd number: ");
            printInt(i);
        }
    }
}

int factorial(int n) {
    if (n <= 1) {
        return 1;
    }
    return n * factorial(n - 1);
}

int main()
{
    testLoops(); // Calling loop test function
    
    int fact = factorial(5);
    printStr("Factorial of 5 is: ");
    printInt(fact);
    printStr("\n");

    int n = 5; // Number of elements
    int arr[5]; // Array of elements
    arr[0] = 2;
    arr[1] = 3;
    arr[2] = 4;
    arr[3] = 10;
    arr[4] = 40;

    // Testing varied initializations
    int _s1a = 20;
    int _s1b = -30;
    int _s1c = -0040;
    int _s1d = 0000030;
    int _s1e = 020;

    int x = 10; // Key to search

    char myChar = '"';
    char* myString = "Hello World'\n//And a comment inside of here /* with a multi-line comment thingy inside! */"; //And a comment outside of here

    /* And a comment inside of here */
    /* And a multi-line
    comment inside of here */

    int result = binarySearch(0, n - 1, x);

    /*
    * Another MLC
    */

    if (result == -1) {
        printStr("Element is not present in array");
    } else {
        printStr("Element is present at index ");
        printInt(result);
    }

    char c = 'c'; // Testing character literals
    printStr("\nCharacter: ");
    printInt(c);
    printStr("\n");

    void* nullPointer = 0; // Testing null pointer

    return 0;

    #THIS IS AN INVALID TOKEN TO APPEAR!
    // This is a comment that will never get tokenized by the lexer because the previous line will error out
}
