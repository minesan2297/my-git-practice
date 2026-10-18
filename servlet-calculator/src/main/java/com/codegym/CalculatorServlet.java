package com.codegym;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CalculatorServlet", urlPatterns = {"/calculate"})
public class CalculatorServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head><title>Result</title></head>");
            out.println("<body style='font-family: Arial, sans-serif; padding: 40px;'>");
            out.println("<h1>Result:</h1>");

            try {
                float firstOperand = Float.parseFloat(request.getParameter("first-operand"));
                float secondOperand = Float.parseFloat(request.getParameter("second-operand"));
                char operator = request.getParameter("operator").charAt(0);

                float result = Calculator.calculate(firstOperand, secondOperand, operator);
                out.println("<p style='font-size: 18px;'>" + firstOperand + " " + operator + " " + secondOperand + " = " + result + "</p>");

            } catch (NumberFormatException ex) {
                out.println("<p style='color: red; font-size: 18px;'>Error: Please enter valid numbers!</p>");
            } catch (RuntimeException ex) {
                out.println("<p style='color: red; font-size: 18px;'>Error: " + ex.getMessage() + "</p>");
            }

            out.println("<br><a href='index.jsp'>Back to Calculator</a>");
            out.println("</body>");
            out.println("</html>");
        }
    }
}
