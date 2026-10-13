package com.codegym;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Endpoint /display-discount nhận request POST từ form tính chiết khấu
@WebServlet(name = "DiscountServlet", urlPatterns = {"/display-discount"})
public class DiscountServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Hỗ trợ Tiếng Việt hiển thị đúng
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            try {
                // 1. Nhận dữ liệu nhập vào từ form
                String description = request.getParameter("description");
                double listPrice = Double.parseDouble(request.getParameter("price"));
                double discountPercent = Double.parseDouble(request.getParameter("discount"));

                // 2. Tính toán theo công thức đề bài:
                // Discount Amount = List Price * Discount Percent * 0.01
                double discountAmount = listPrice * discountPercent * 0.01;
                // Discount Price = List Price - Discount Amount
                double discountPrice = listPrice - discountAmount;

                // 3. Hiển thị trang kết quả
                out.println("<!DOCTYPE html>");
                out.println("<html>");
                out.println("<head><title>Discount Calculation Result</title></head>");
                out.println("<body style='font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; background-color: #f8fafc;'>");
                out.println("<div style='background: white; padding: 40px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 420px; text-align: left;'>");
                out.println("<h2 style='color: #1b2a7a; text-align: center; margin-bottom: 25px;'>Product Discount Calculator</h2>");
                out.println("<hr style='border: 0; border-top: 1px solid #e2e8f0; margin-bottom: 20px;'>");
                
                out.println("<p style='font-size: 16px; margin: 12px 0;'><strong>Product Description:</strong> <span style='color: #334155;'>" + description + "</span></p>");
                out.println("<p style='font-size: 16px; margin: 12px 0;'><strong>List Price:</strong> <span style='color: #334155;'>$" + String.format("%,.2f", listPrice) + "</span></p>");
                out.println("<p style='font-size: 16px; margin: 12px 0;'><strong>Discount Percent:</strong> <span style='color: #334155;'>" + discountPercent + "%</span></p>");
                
                out.println("<div style='background-color: #f1f5f9; padding: 16px; border-radius: 6px; margin: 20px 0;'>");
                out.println("<p style='font-size: 17px; margin: 8px 0; color: #d97706;'><strong>Discount Amount:</strong> $" + String.format("%,.2f", discountAmount) + "</p>");
                out.println("<p style='font-size: 18px; margin: 8px 0; color: #16a34a;'><strong>Discount Price:</strong> $" + String.format("%,.2f", discountPrice) + "</p>");
                out.println("</div>");

                out.println("<div style='text-align: center; margin-top: 25px;'>");
                out.println("<a href='index.jsp' style='text-decoration: none; padding: 12px 28px; background-color: #1b2a7a; color: white; border-radius: 4px; font-weight: bold; display: inline-block;'>Calculate Another</a>");
                out.println("</div>");

                out.println("</div>");
                out.println("</body>");
                out.println("</html>");

            } catch (NumberFormatException e) {
                out.println("<!DOCTYPE html><html><body style='font-family: Arial; text-align: center; margin-top: 100px;'>");
                out.println("<h2 style='color: red;'>Lỗi: Vui lòng nhập số hợp lệ cho giá và tỷ lệ chiết khấu!</h2>");
                out.println("<a href='index.jsp'>Quay lại</a>");
                out.println("</body></html>");
            }
        }
    }
}
