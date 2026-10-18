package com.codegym;

public class Main {
    public static void main(String[] args) {
        System.out.println("=== THỬ NGHIỆM THƯ VIỆN GIẢI PHƯƠNG TRÌNH BẬC 2 (quadratic-equation-lib.jar) ===");

        // Trường hợp 1: 2 nghiệm phân biệt: x^2 - 7x + 10 = 0 (x1 = 5, x2 = 2)
        System.out.println("\n1. Phương trình x^2 - 7x + 10 = 0:");
        QuadraticEquation eq1 = new QuadraticEquation(1, -7, 10);
        System.out.println("   Delta: " + eq1.getDiscriminant());
        System.out.println("   Nghiệm x1: " + eq1.getRoot1());
        System.out.println("   Nghiệm x2: " + eq1.getRoot2());
        System.out.println("   Kết luận (solve): " + QuadraticEquation.solve(1, -7, 10));

        // Trường hợp 2: Nghiệm kép: x^2 - 4x + 4 = 0 (x1 = x2 = 2)
        System.out.println("\n2. Phương trình x^2 - 4x + 4 = 0:");
        QuadraticEquation eq2 = new QuadraticEquation(1, -4, 4);
        System.out.println("   Delta: " + eq2.getDiscriminant());
        System.out.println("   Nghiệm x1: " + eq2.getRoot1());
        System.out.println("   Nghiệm x2: " + eq2.getRoot2());
        System.out.println("   Kết luận (solve): " + QuadraticEquation.solve(1, -4, 4));

        // Trường hợp 3: Vô nghiệm: x^2 + 2x + 5 = 0 (Delta < 0)
        System.out.println("\n3. Phương trình x^2 + 2x + 5 = 0:");
        System.out.println("   Kết luận (solve): " + QuadraticEquation.solve(1, 2, 5));

        // Trường hợp 4: a = 0 (Phương trình bậc nhất 2x - 6 = 0 -> x = 3)
        System.out.println("\n4. Phương trình bậc nhất 2x - 6 = 0 (a = 0):");
        System.out.println("   Kết luận (solve): " + QuadraticEquation.solve(0, 2, -6));
    }
}
