package com.codegym.strategy;

import com.codegym.model.Note;
import com.codegym.model.NoteType;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NoteFileStrategy implements NoteStrategy {
    private final String filePath;
    private final Map<Integer, NoteType> noteTypeMap = new HashMap<>();

    public NoteFileStrategy() {
        // Mặc định lưu trữ file notes_data.txt trong thư mục người dùng hoặc thư mục tạm an toàn
        String userHome = System.getProperty("user.home");
        this.filePath = userHome + File.separator + "inotes_data.txt";
        initNoteTypes();
        initDefaultFileIfNotExist();
    }

    public NoteFileStrategy(String filePath) {
        this.filePath = filePath;
        initNoteTypes();
        initDefaultFileIfNotExist();
    }

    private void initNoteTypes() {
        noteTypeMap.put(1, new NoteType(1, "Cá nhân", "Ghi chú sinh hoạt, cá nhân"));
        noteTypeMap.put(2, new NoteType(2, "Công việc", "Ghi chú công việc, dự án"));
        noteTypeMap.put(3, new NoteType(3, "Học tập", "Ghi chú học tập, nghiên cứu"));
    }

    private void initDefaultFileIfNotExist() {
        File file = new File(filePath);
        if (!file.exists()) {
            try {
                if (file.getParentFile() != null) {
                    file.getParentFile().mkdirs();
                }
                file.createNewFile();
                // Khởi tạo một số dữ liệu mẫu ban đầu
                List<Note> sampleNotes = new ArrayList<>();
                sampleNotes.add(new Note(1, "Họp giao ban đầu tuần", "Báo cáo tiến độ hoàn thành các bài thực hành JSP Servlet và phân chia công việc tuần mới.", 2));
                sampleNotes.add(new Note(2, "Ôn tập Design Pattern Servlet", "Nghiên cứu áp dụng Strategy Pattern, Singleton Pattern và MVC Architecture.", 3));
                sampleNotes.add(new Note(3, "Kế hoạch rèn luyện cá nhân", "Chạy bộ buổi sáng và đọc sách công nghệ 30 phút mỗi ngày.", 1));
                writeNotesToFile(sampleNotes);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public String getStrategyName() {
        return "Tập tin Văn bản (Text File Storage)";
    }

    // Đọc danh sách Note từ file định dạng: id|title|content|typeId
    // Để an toàn với ký tự xuống dòng trong content, encode newlines thành "\\n"
    private synchronized List<Note> readNotesFromFile() {
        List<Note> list = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) {
            return list;
        }

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(file), StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] parts = line.split("\\|", 4);
                if (parts.length >= 4) {
                    int id = Integer.parseInt(parts[0]);
                    String title = decodeDelimiters(parts[1]);
                    String content = decodeDelimiters(parts[2]);
                    int typeId = Integer.parseInt(parts[3]);

                    NoteType noteType = noteTypeMap.getOrDefault(typeId, new NoteType(typeId, "Khác"));
                    list.add(new Note(id, title, content, typeId, noteType));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private synchronized void writeNotesToFile(List<Note> list) {
        File file = new File(filePath);
        try (BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file, false), StandardCharsets.UTF_8))) {
            for (Note note : list) {
                String safeTitle = encodeDelimiters(note.getTitle());
                String safeContent = encodeDelimiters(note.getContent());
                writer.write(note.getId() + "|" + safeTitle + "|" + safeContent + "|" + note.getTypeId());
                writer.newLine();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String encodeDelimiters(String input) {
        if (input == null) return "";
        return input.replace("|", "&#124;").replace("\r", "").replace("\n", "\\n");
    }

    private String decodeDelimiters(String input) {
        if (input == null) return "";
        return input.replace("\\n", "\n").replace("&#124;", "|");
    }

    @Override
    public synchronized void save(Note note) {
        List<Note> notes = readNotesFromFile();
        if (note.getId() > 0) {
            // Update
            boolean found = false;
            for (int i = 0; i < notes.size(); i++) {
                if (notes.get(i).getId() == note.getId()) {
                    Note existing = notes.get(i);
                    existing.setTitle(note.getTitle());
                    existing.setContent(note.getContent());
                    existing.setTypeId(note.getTypeId());
                    existing.setNoteType(noteTypeMap.getOrDefault(note.getTypeId(), new NoteType(note.getTypeId(), "Khác")));
                    found = true;
                    break;
                }
            }
            if (!found) {
                notes.add(note);
            }
        } else {
            // Insert mới: tính id lớn nhất + 1
            int maxId = 0;
            for (Note n : notes) {
                if (n.getId() > maxId) {
                    maxId = n.getId();
                }
            }
            note.setId(maxId + 1);
            note.setNoteType(noteTypeMap.getOrDefault(note.getTypeId(), new NoteType(note.getTypeId(), "Khác")));
            notes.add(note);
        }
        writeNotesToFile(notes);
    }

    @Override
    public synchronized void delete(int id) {
        List<Note> notes = readNotesFromFile();
        notes.removeIf(n -> n.getId() == id);
        writeNotesToFile(notes);
    }

    @Override
    public synchronized List<Note> findAll() {
        List<Note> notes = readNotesFromFile();
        // Sắp xếp ID giảm dần (mới nhất lên đầu)
        notes.sort((a, b) -> Integer.compare(b.getId(), a.getId()));
        return notes;
    }

    @Override
    public synchronized List<Note> search(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll();
        }
        String lowerKey = keyword.trim().toLowerCase();
        List<Note> all = findAll();
        List<Note> result = new ArrayList<>();
        for (Note n : all) {
            boolean matchTitle = n.getTitle() != null && n.getTitle().toLowerCase().contains(lowerKey);
            boolean matchContent = n.getContent() != null && n.getContent().toLowerCase().contains(lowerKey);
            if (matchTitle || matchContent) {
                result.add(n);
            }
        }
        return result;
    }

    @Override
    public synchronized Note findById(int id) {
        List<Note> notes = readNotesFromFile();
        for (Note n : notes) {
            if (n.getId() == id) {
                return n;
            }
        }
        return null;
    }

    @Override
    public List<NoteType> findAllNoteTypes() {
        return new ArrayList<>(noteTypeMap.values());
    }

    public String getFilePath() {
        return filePath;
    }
}
