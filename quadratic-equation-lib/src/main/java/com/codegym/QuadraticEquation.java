package com.codegym;

public class QuadraticEquation {
    private final double a;
    private final double b;
    private final double c;

    public QuadraticEquation(double a, double b, double c) {
        this.a = a;
        this.b = b;
        this.c = c;
    }

    public double getA() {
        return a;
    }

    public double getB() {
        return b;
    }

    public double getC() {
        return c;
    }

    public double getDiscriminant() {
        return (b * b) - (4 * a * c);
    }

    public double getRoot1() {
        double delta = getDiscriminant();
        if (delta < 0) {
            return 0;
        }
        return (-b + Math.sqrt(delta)) / (2 * a);
    }

    public double getRoot2() {
        double delta = getDiscriminant();
        if (delta < 0) {
            return 0;
        }
        return (-b - Math.sqrt(delta)) / (2 * a);
    }

    public static String solve(double a, double b, double c) {
        if (a == 0) {
            if (b == 0) {
                if (c == 0) {
                    return "Phương trình có vô số nghiệm.";
                } else {
                    return "Phương trình vô nghiệm.";
                }
            } else {
                double root = -c / b;
                return "Phương trình bậc nhất, có 1 nghiệm: x = " + root;
            }
        }

        double delta = (b * b) - (4 * a * c);
        if (delta < 0) {
            return "Phương trình vô nghiệm (Delta = " + delta + " < 0).";
        } else if (delta == 0) {
            double root = -b / (2 * a);
            return "Phương trình có nghiệm kép: x1 = x2 = " + root;
        } else {
            double r1 = (-b + Math.sqrt(delta)) / (2 * a);
            double r2 = (-b - Math.sqrt(delta)) / (2 * a);
            return "Phương trình có 2 nghiệm phân biệt: x1 = " + r1 + ", x2 = " + r2;
        }
    }
}
