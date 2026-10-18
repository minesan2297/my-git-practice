package com.codegym.dao;

import com.codegym.model.User;
import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class UserDAO implements IUserDAO {
    // Lưu ý cấu hình kết nối MySQL trên máy tính
    private String jdbcURL = "jdbc:mysql://localhost:3306/demo?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private String jdbcUsername = "root";
    private String jdbcPassword = "password";

    private static final String INSERT_USERS_SQL = "INSERT INTO users (name, email, country) VALUES (?, ?, ?);";
    private static final String SELECT_USER_BY_ID = "SELECT id, name, email, country FROM users WHERE id = ?;";
    private static final String SELECT_ALL_USERS = "SELECT * FROM users;";
    private static final String DELETE_USERS_SQL = "DELETE FROM users WHERE id = ?;";
    private static final String UPDATE_USERS_SQL = "UPDATE users SET name = ?, email = ?, country = ? WHERE id = ?;";
    private static final String SELECT_USERS_BY_COUNTRY = "SELECT id, name, email, country FROM users WHERE country LIKE ?;";
    private static final String SELECT_ALL_USERS_SORT_NAME_ASC = "SELECT id, name, email, country FROM users ORDER BY name ASC;";
    private static final String SELECT_ALL_USERS_SORT_NAME_DESC = "SELECT id, name, email, country FROM users ORDER BY name DESC;";

    private static final String SQL_INSERT = "INSERT INTO Employee (name, salary, created_Date) VALUES (?,?,?)";
    private static final String SQL_UPDATE = "UPDATE Employee SET salary=? WHERE name=?";
    private static final String SQL_TABLE_CREATE = "CREATE TABLE Employee" + "(" + " id INT(11) AUTO_INCREMENT," + " name VARCHAR(100) NOT NULL," + " salary DECIMAL(15, 2) NOT NULL," + " created_Date TIMESTAMP," + " PRIMARY KEY (id)" + ")";
    private static final String SQL_TABLE_DROP = "DROP TABLE IF EXISTS Employee";

    public UserDAO() {}

    public UserDAO(String jdbcURL, String jdbcUsername, String jdbcPassword) {
        this.jdbcURL = jdbcURL;
        this.jdbcUsername = jdbcUsername;
        this.jdbcPassword = jdbcPassword;
    }

    protected Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return connection;
    }

    @Override
    public void insertUser(User user) throws Exception {
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_USERS_SQL)) {
            preparedStatement.setString(1, user.getName());
            preparedStatement.setString(2, user.getEmail());
            preparedStatement.setString(3, user.getCountry());
            preparedStatement.executeUpdate();
        }
    }

    @Override
    public User selectUser(int id) {
        User user = null;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USER_BY_ID)) {
            preparedStatement.setInt(1, id);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                String name = rs.getString("name");
                String email = rs.getString("email");
                String country = rs.getString("country");
                user = new User(id, name, email, country);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    @Override
    public List<User> selectAllUsers() {
        List<User> users = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_USERS)) {
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String email = rs.getString("email");
                String country = rs.getString("country");
                users.add(new User(id, name, email, country));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public boolean deleteUser(int id) throws Exception {
        boolean rowDeleted;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_USERS_SQL)) {
            statement.setInt(1, id);
            rowDeleted = statement.executeUpdate() > 0;
        }
        return rowDeleted;
    }

    @Override
    public boolean updateUser(User user) throws Exception {
        boolean rowUpdated;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_USERS_SQL)) {
            statement.setString(1, user.getName());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getCountry());
            statement.setInt(4, user.getId());
            rowUpdated = statement.executeUpdate() > 0;
        }
        return rowUpdated;
    }

    @Override
    public List<User> findByCountry(String country) {
        List<User> users = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USERS_BY_COUNTRY)) {
            preparedStatement.setString(1, "%" + (country != null ? country.trim() : "") + "%");
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String email = rs.getString("email");
                String userCountry = rs.getString("country");
                users.add(new User(id, name, email, userCountry));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public List<User> sortByName(String order) {
        List<User> users = new ArrayList<>();
        String sql = (order != null && order.equalsIgnoreCase("desc"))
                ? SELECT_ALL_USERS_SORT_NAME_DESC
                : SELECT_ALL_USERS_SORT_NAME_ASC;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String email = rs.getString("email");
                String country = rs.getString("country");
                users.add(new User(id, name, email, country));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public User getUserById(int id) {
        User user = null;
        String query = "{CALL get_user_by_id(?)}";
        try (Connection connection = getConnection();
             CallableStatement callableStatement = connection.prepareCall(query)) {
            callableStatement.setInt(1, id);
            ResultSet rs = callableStatement.executeQuery();
            while (rs.next()) {
                String name = rs.getString("name");
                String email = rs.getString("email");
                String country = rs.getString("country");
                user = new User(id, name, email, country);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    @Override
    public void insertUserStore(User user) throws SQLException {
        String query = "{CALL insert_user(?, ?, ?)}";
        try (Connection connection = getConnection();
             CallableStatement callableStatement = connection.prepareCall(query)) {
            callableStatement.setString(1, user.getName());
            callableStatement.setString(2, user.getEmail());
            callableStatement.setString(3, user.getCountry());
            callableStatement.executeUpdate();
        }
    }

    @Override
    public void addUserTransaction(User user, int[] permissionIds) throws SQLException {
        Connection connection = null;
        PreparedStatement pstmtUser = null;
        PreparedStatement pstmtAssignment = null;
        ResultSet rs = null;
        try {
            connection = getConnection();
            // 1. Tắt auto-commit để bắt đầu một Transaction
            connection.setAutoCommit(false);

            // 2. Chèn dữ liệu vào bảng users và cấu hình lấy lại ID vừa tạo
            String insertUserSql = "INSERT INTO users (name, email, country) VALUES (?, ?, ?)";
            pstmtUser = connection.prepareStatement(insertUserSql, Statement.RETURN_GENERATED_KEYS);
            pstmtUser.setString(1, user.getName());
            pstmtUser.setString(2, user.getEmail());
            pstmtUser.setString(3, user.getCountry());
            pstmtUser.executeUpdate();

            // 3. Lấy ID của user vừa được chèn
            rs = pstmtUser.getGeneratedKeys();
            int userId = 0;
            if (rs.next()) {
                userId = rs.getInt(1);
            }

            // 4. Chèn dữ liệu vào bảng user_permission
            if (permissionIds != null && permissionIds.length > 0) {
                String insertPermissionSql = "INSERT INTO user_permission (user_id, permission_id) VALUES (?, ?)";
                pstmtAssignment = connection.prepareStatement(insertPermissionSql);
                for (int permissionId : permissionIds) {
                    pstmtAssignment.setInt(1, userId);
                    pstmtAssignment.setInt(2, permissionId);
                    pstmtAssignment.executeUpdate();
                }
            }

            // 5. Nếu mọi thứ thành công, tiến hành Commit
            connection.commit();
            System.out.println("Transaction đã được commit thành công!");
        } catch (SQLException e) {
            // 6. Nếu có lỗi xảy ra ở bất kỳ đâu, Rollback lại toàn bộ dữ liệu
            try {
                if (connection != null) {
                    connection.rollback();
                    System.out.println("Có lỗi xảy ra! Transaction đã bị rollback.");
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            throw e;
        } finally {
            // 7. Dọn dẹp tài nguyên và bật lại auto-commit
            if (rs != null) rs.close();
            if (pstmtUser != null) pstmtUser.close();
            if (pstmtAssignment != null) pstmtAssignment.close();
            if (connection != null) {
                connection.setAutoCommit(true);
                connection.close();
            }
        }
    }

    @Override
    public void addUserTransactionFail(User user, int[] permissionIds) throws SQLException {
        Connection connection = null;
        PreparedStatement pstmtUser = null;
        PreparedStatement pstmtAssignment = null;
        ResultSet rs = null;
        try {
            connection = getConnection();
            // 1. Tắt auto-commit để bắt đầu Transaction
            connection.setAutoCommit(false);

            // 2. Chèn dữ liệu vào bảng users
            String insertUserSql = "INSERT INTO users (name, email, country) VALUES (?, ?, ?)";
            pstmtUser = connection.prepareStatement(insertUserSql, Statement.RETURN_GENERATED_KEYS);
            pstmtUser.setString(1, user.getName());
            pstmtUser.setString(2, user.getEmail());
            pstmtUser.setString(3, user.getCountry());
            pstmtUser.executeUpdate();

            // 3. Lấy ID của user vừa được chèn
            rs = pstmtUser.getGeneratedKeys();
            int userId = 0;
            if (rs.next()) {
                userId = rs.getInt(1);
            }

            // 4. Cố tình gây lỗi SQL ở bước chèn bảng user_permission:
            // Cố tình viết sai tên bảng thành `non_existent_table` để gây ra lỗi SQLException
            String invalidInsertSql = "INSERT INTO non_existent_table (user_id, permission_id) VALUES (?, ?)";
            pstmtAssignment = connection.prepareStatement(invalidInsertSql);
            if (permissionIds != null && permissionIds.length > 0) {
                for (int permissionId : permissionIds) {
                    pstmtAssignment.setInt(1, userId);
                    pstmtAssignment.setInt(2, permissionId);
                    pstmtAssignment.executeUpdate(); // Sẽ ném SQLException tại đây
                }
            } else {
                pstmtAssignment.setInt(1, userId);
                pstmtAssignment.setInt(2, 1);
                pstmtAssignment.executeUpdate(); // Sẽ ném SQLException tại đây
            }

            // 5. Nếu không có lỗi thì mới commit (đoạn này sẽ không tới được)
            connection.commit();
            System.out.println("Transaction thành công!");
        } catch (SQLException e) {
            // 6. Bắt được lỗi SQL -> Thực hiện ROLLBACK
            System.out.println(">>> ĐÃ BẮT ĐƯỢC LỖI SQL TRONG TRANSACTION <<<");
            System.out.println("Thông báo lỗi: " + e.getMessage());
            try {
                if (connection != null) {
                    connection.rollback();
                    System.out.println(">>> TRANSACTION ĐÃ BỊ ROLLBACK THÀNH CÔNG! Bảng users không bị ghi dữ liệu rác. <<<");
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            throw e;
        } finally {
            // 7. Dọn dẹp tài nguyên
            if (rs != null) rs.close();
            if (pstmtUser != null) pstmtUser.close();
            if (pstmtAssignment != null) pstmtAssignment.close();
            if (connection != null) {
                connection.setAutoCommit(true);
                connection.close();
            }
        }
    }

    @Override
    public void insertUpdateWithoutTransaction() {
        try (Connection conn = getConnection();
             Statement statement = conn.createStatement();
             PreparedStatement psInsert = conn.prepareStatement(SQL_INSERT);
             PreparedStatement psUpdate = conn.prepareStatement(SQL_UPDATE)) {

            // 1. Xoá bảng cũ và tạo lại bảng mới để làm sạch dữ liệu mỗi lần test
            statement.execute(SQL_TABLE_DROP);
            statement.execute(SQL_TABLE_CREATE);

            // 2. Chạy tập lệnh Insert (Chèn 2 nhân viên)
            psInsert.setString(1, "Quynh");
            psInsert.setBigDecimal(2, new BigDecimal(10));
            psInsert.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            psInsert.execute();

            psInsert.setString(1, "Ngan");
            psInsert.setBigDecimal(2, new BigDecimal(20));
            psInsert.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            psInsert.execute();

            // 3. Chạy tập lệnh Update (Cố tình tạo lỗi)
            // Dòng bên dưới sẽ gây lỗi vì tham số index 1 chưa được gán giá trị
            psUpdate.setBigDecimal(2, new BigDecimal(999.99));
            // Lệnh đúng ra phải là: psUpdate.setBigDecimal(1, new BigDecimal(999.99));
            psUpdate.setString(2, "Quynh");

            // Lệnh execute này sẽ ném ra Exception
            psUpdate.execute();

        } catch (Exception e) {
            System.out.println("Đã bắt được lỗi trong quá trình thực thi SQL:");
            e.printStackTrace();
        }
    }

    @Override
    public void insertUpdateUseTransaction() {
        try (Connection conn = getConnection();
             Statement statement = conn.createStatement();
             PreparedStatement psInsert = conn.prepareStatement(SQL_INSERT);
             PreparedStatement psUpdate = conn.prepareStatement(SQL_UPDATE)) {

            statement.execute(SQL_TABLE_DROP);
            statement.execute(SQL_TABLE_CREATE);

            // ==========================================
            // 1. BẮT ĐẦU TRANSACTION BLOCK
            // Tắt chế độ lưu tự động (mặc định là true)
            // ==========================================
            conn.setAutoCommit(false);

            // 2. Chạy danh sách lệnh Insert
            psInsert.setString(1, "Quynh");
            psInsert.setBigDecimal(2, new BigDecimal(10));
            psInsert.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            psInsert.execute();

            psInsert.setString(1, "Ngan");
            psInsert.setBigDecimal(2, new BigDecimal(20));
            psInsert.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            psInsert.execute();

            // 3. Chạy lệnh Update
            // Để ứng dụng hoạt động chuẩn xác theo Bước 4 (Lần 2), gán index 1:
            psUpdate.setBigDecimal(1, new BigDecimal(999.99));
            psUpdate.setString(2, "Quynh");
            psUpdate.execute();

            // ==========================================
            // 4. KẾT THÚC TRANSACTION BLOCK
            // Nếu code chạy trót lọt đến đây, tiến hành ghi dữ liệu
            // ==========================================
            conn.commit();

            // Thói quen tốt: Bật lại chế độ auto-commit về mặc định
            conn.setAutoCommit(true);
            System.out.println("Transaction thành công và đã được commit!");

        } catch (Exception e) {
            System.out.println("Lỗi xảy ra, Transaction sẽ tự động huỷ bỏ (rollback) khi đóng kết nối!");
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public List<User> getAllUsersStore() {
        List<User> users = new ArrayList<>();
        String query = "{CALL get_all_users()}";
        try (Connection connection = getConnection();
             CallableStatement callableStatement = connection.prepareCall(query);
             ResultSet rs = callableStatement.executeQuery()) {
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String email = rs.getString("email");
                String country = rs.getString("country");
                users.add(new User(id, name, email, country));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public boolean updateUserStore(User user) throws Exception {
        boolean rowUpdated;
        String query = "{CALL update_user(?, ?, ?, ?)}";
        try (Connection connection = getConnection();
             CallableStatement callableStatement = connection.prepareCall(query)) {
            callableStatement.setInt(1, user.getId());
            callableStatement.setString(2, user.getName());
            callableStatement.setString(3, user.getEmail());
            callableStatement.setString(4, user.getCountry());
            rowUpdated = callableStatement.executeUpdate() > 0;
        }
        return rowUpdated;
    }

    @Override
    public boolean deleteUserStore(int id) throws Exception {
        boolean rowDeleted;
        String query = "{CALL delete_user(?)}";
        try (Connection connection = getConnection();
             CallableStatement callableStatement = connection.prepareCall(query)) {
            callableStatement.setInt(1, id);
            rowDeleted = callableStatement.executeUpdate() > 0;
        }
        return rowDeleted;
    }
}
