#include <stdio.h>
#include <string.h>

typedef enum { TYPE_INT, TYPE_FLOAT, TYPE_ERROR } DataType;

const char* type_to_string(DataType t) {
    if (t == TYPE_INT) return "int";
    if (t == TYPE_FLOAT) return "float";
    return "error";
}

DataType get_var_type(char var) {
    if (var == 'a' || var == 'b') return TYPE_INT;
    if (var == 'c') return TYPE_FLOAT;
    return TYPE_ERROR;
}

DataType evaluate_op(DataType left, DataType right, char op) {
    if (left == TYPE_ERROR || right == TYPE_ERROR) return TYPE_ERROR;
    if (left == TYPE_FLOAT || right == TYPE_FLOAT) return TYPE_FLOAT;
    return TYPE_INT;
}

int main() {
    printf("Symbol Table:\n");
    printf("a : int\n");
    printf("b : int\n");
    printf("c : float\n\n");
    printf("Input Expression: a + b * c\n\n");

    DataType type_a = get_var_type('a');
    DataType type_b = get_var_type('b');
    DataType type_c = get_var_type('c');

    // Subexpression 1: b * c
    DataType type_term = evaluate_op(type_b, type_c, '*');
    printf("Subexpression 'b * c': %s * %s -> Type = %s\n", 
           type_to_string(type_b), type_to_string(type_c), type_to_string(type_term));

    // Subexpression 2: a + (b * c)
    DataType final_type = evaluate_op(type_a, type_term, '+');
    printf("Subexpression 'a + (b * c)': %s + %s -> Type = %s\n\n", 
           type_to_string(type_a), type_to_string(type_term), type_to_string(final_type));

    printf("Final Expression Type: %s\n", type_to_string(final_type));

    return 0;
}