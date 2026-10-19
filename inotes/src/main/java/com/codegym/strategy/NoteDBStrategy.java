package com.codegym.strategy;

import com.codegym.model.Note;
import com.codegym.model.NoteType;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class NoteDBStrategy implements NoteStrategy {
    private String jdbcURL = "jdbc:mysql://localhost:3306/inotes_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&useUnicode=true&characterEncoding=UTF-8";
    private String jdbcUsername = "root";
    private String jdbcPassword = "password";

    public NoteDBStrategy() {
    }

    public NoteDBStrategy(String jdbcURL, String jdbcUsername, String jdbcPassword) {
        this.jdbcURL = jdbcURL;
        this.jdbcUsername = jdbcUsername;
        this.jdbcPassword = jdbcPassword;
    }

    protected Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    @Override
    public String getStrategyName() {
        return "Cơ sở dữ liệu (MySQL DB)";
    }

    @Override
    public void save(Note note) {
        if (note.getId() > 0 && findById(note.getId()) != null) {
            // Update existing note
            String updateSql = "UPDATE notes SET title = ?, content = ?, type_id = ? WHERE id = ?;";
            try (Connection conn = getConnection();
                 PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setString(1, note.getTitle());
                ps.setString(2, note.getContent());
                ps.setInt(3, note.getTypeId());
                ps.setInt(4, note.getId());
                ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            // Insert new note
            String insertSql = "INSERT INTO notes (title, content, type_id) VALUES (?, ?, ?);";
            try (Connection conn = getConnection();
                 PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, note.getTitle());
                ps.setString(2, note.getContent());
                ps.setInt(3, note.getTypeId());
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        note.setId(rs.getInt(1));
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void delete(int id) {
        String deleteSql = "DELETE FROM notes WHERE id = ?;";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(deleteSql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Note> findAll() {
        List<Note> list = new ArrayList<>();
        String query = "SELECT n.id, n.title, n.content, n.type_id, t.name AS type_name, t.description AS type_desc " +
                "FROM notes n LEFT JOIN note_type t ON n.type_id = t.id ORDER BY n.id DESC;";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int id = rs.getInt("id");
                String title = rs.getString("title");
                String content = rs.getString("content");
                int typeId = rs.getInt("type_id");
                String typeName = rs.getString("type_name");
                String typeDesc = rs.getString("type_desc");

                NoteType noteType = new NoteType(typeId, typeName != null ? typeName : "Khác", typeDesc);
                list.add(new Note(id, title, content, typeId, noteType));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Note> search(String keyword) {
        List<Note> list = new ArrayList<>();
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll();
        }
        String query = "SELECT n.id, n.title, n.content, n.type_id, t.name AS type_name, t.description AS type_desc " +
                "FROM notes n LEFT JOIN note_type t ON n.type_id = t.id " +
                "WHERE n.title LIKE ? OR n.content LIKE ? ORDER BY n.id DESC;";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            String pattern = "%" + keyword.trim() + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String title = rs.getString("title");
                    String content = rs.getString("content");
                    int typeId = rs.getInt("type_id");
                    String typeName = rs.getString("type_name");
                    String typeDesc = rs.getString("type_desc");

                    NoteType noteType = new NoteType(typeId, typeName != null ? typeName : "Khác", typeDesc);
                    list.add(new Note(id, title, content, typeId, noteType));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Note findById(int id) {
        String query = "SELECT n.id, n.title, n.content, n.type_id, t.name AS type_name, t.description AS type_desc " +
                "FROM notes n LEFT JOIN note_type t ON n.type_id = t.id WHERE n.id = ?;";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String title = rs.getString("title");
                    String content = rs.getString("content");
                    int typeId = rs.getInt("type_id");
                    String typeName = rs.getString("type_name");
                    String typeDesc = rs.getString("type_desc");

                    NoteType noteType = new NoteType(typeId, typeName != null ? typeName : "Khác", typeDesc);
                    return new Note(id, title, content, typeId, noteType);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<NoteType> findAllNoteTypes() {
        List<NoteType> list = new ArrayList<>();
        String query = "SELECT id, name, description FROM note_type ORDER BY id ASC;";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new NoteType(rs.getInt("id"), rs.getString("name"), rs.getString("description")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (list.isEmpty()) {
            list.add(new NoteType(1, "Cá nhân", "Ghi chú cá nhân"));
            list.add(new NoteType(2, "Công việc", "Ghi chú công việc"));
            list.add(new NoteType(3, "Học tập", "Ghi chú học tập"));
        }
        return list;
    }
}
