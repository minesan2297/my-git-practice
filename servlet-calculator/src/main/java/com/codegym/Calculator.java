package com.codegym;

public class Calculator {

    public static float calculate(float firstOperand, float secondOperand, char operator) {
        switch (operator) {
            case '+':
                return firstOperand + secondOperand;
            case '-':
                return firstOperand - secondOperand;
            case '*':
                return firstOperand * secondOperand;
            case '/':
                if (secondOperand == 0) {
                    throw new RuntimeException("Can't divide by zero");
                }
                return firstOperand / secondOperand;
            default:
                throw new RuntimeException("Invalid operation");
        }
    }
}
