package com.codegym;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Khai báo định tuyến URL: Khi submit form tới "/convert", Servlet này sẽ được kích hoạt
@WebServlet(name = "ConverterServlet", urlPatterns = {"/convert"})
public class ConverterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Cấu hình phản hồi hiển thị HTML và hỗ trợ Tiếng Việt có dấu
        response.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            try {
                // Nhận tham số từ form và ép kiểu sang số thực
                float rate = Float.parseFloat(request.getParameter("rate"));
                float usd = Float.parseFloat(request.getParameter("usd"));

                // Thực hiện tính toán chuyển đổi tiền tệ
                float vnd = rate * usd;

                // Hiển thị kết quả ra giao diện
                out.println("<!DOCTYPE html>");
                out.println("<html>");
                out.println("<head><title>Result - Kết Quả Chuyển Đổi</title></head>");
                out.println("<body style='font-family: Arial, sans-serif; text-align: center; margin-top: 100px; background-color: #f8fafc;'>");
                out.println("<div style='display: inline-block; background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); width: 380px;'>");
                out.println("<h2 style='color: #1b2a7a;'>KẾT QUẢ CHUYỂN ĐỔI</h2>");
                out.println("<hr style='border: 0; border-top: 1px solid #eee; margin: 20px 0;'>");
                out.println("<p style='font-size: 18px; color: #475569;'>Tỉ giá: <strong>" + String.format("%,.0f", rate) + " VND/USD</strong></p>");
                out.println("<p style='font-size: 18px; color: #475569;'>Số tiền USD: <strong>$" + String.format("%,.2f", usd) + "</strong></p>");
                out.println("<h3 style='color: #27ae60; font-size: 24px; margin-top: 25px;'>Thành tiền VNĐ: <br>" + String.format("%,.0f", vnd) + " VNĐ</h3>");
                out.println("<br><a href='index.jsp' style='text-decoration: none; padding: 12px 24px; background-color: #1b2a7a; color: white; border-radius: 4px; font-weight: bold; display: inline-block; margin-top: 10px;'>Quay lại</a>");
                out.println("</div>");
                out.println("</body>");
                out.println("</html>");
            } catch (NumberFormatException e) {
                // Xử lý ngoại lệ nếu người dùng nhập ký tự không phải số
                out.println("<!DOCTYPE html>");
                out.println("<html><body style='font-family: Arial, sans-serif; text-align: center; margin-top: 100px;'>");
                out.println("<h2 style='color: red;'>Lỗi: Vui lòng nhập số hợp lệ!</h2>");
                out.println("<div style='margin-top: 20px;'><a href='index.jsp' style='text-decoration: none; padding: 10px 20px; background-color: #1b2a7a; color: white; border-radius: 4px;'>Quay lại</a></div>");
                out.println("</body></html>");
            }
        }
    }
}
