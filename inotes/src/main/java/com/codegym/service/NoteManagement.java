package com.codegym.service;

import com.codegym.model.Note;
import com.codegym.model.NoteType;
import com.codegym.strategy.NoteDBStrategy;
import com.codegym.strategy.NoteFileStrategy;
import com.codegym.strategy.NoteStrategy;

import java.util.List;

public class NoteManagement {
    private NoteStrategy strategy;

    public NoteManagement() {
        // Mặc định khởi tạo với Database Strategy
        this.strategy = new NoteDBStrategy();
    }

    public NoteManagement(NoteStrategy strategy) {
        this.strategy = strategy;
    }

    public NoteStrategy getStrategy() {
        return strategy;
    }

    // Cho phép hoán đổi chiến lược lưu trữ linh hoạt lúc runtime (Runtime Pluggable Storage)
    public void setStrategy(NoteStrategy strategy) {
        this.strategy = strategy;
    }

    // Chuyển đổi chiến lược dựa trên chuỗi định danh ("db" hoặc "file")
    public void switchStrategy(String type) {
        if ("file".equalsIgnoreCase(type)) {
            if (!(this.strategy instanceof NoteFileStrategy)) {
                this.strategy = new NoteFileStrategy();
            }
        } else {
            if (!(this.strategy instanceof NoteDBStrategy)) {
                this.strategy = new NoteDBStrategy();
            }
        }
    }

    public String getCurrentStrategyType() {
        if (this.strategy instanceof NoteFileStrategy) {
            return "file";
        }
        return "db";
    }

    public String getCurrentStrategyName() {
        return this.strategy != null ? this.strategy.getStrategyName() : "Chưa chọn";
    }

    public List<Note> getAllNotes() {
        return this.strategy.findAll();
    }

    public List<Note> searchNotes(String keyword) {
        return this.strategy.search(keyword);
    }

    public void addNote(String title, String content, int typeId) {
        Note note = new Note(title, content, typeId);
        this.strategy.save(note);
    }

    public void updateNote(int id, String title, String content, int typeId) {
        Note note = new Note(id, title, content, typeId);
        this.strategy.save(note);
    }

    public void deleteNote(int id) {
        this.strategy.delete(id);
    }

    public Note getNoteById(int id) {
        return this.strategy.findById(id);
    }

    public List<NoteType> getAllNoteTypes() {
        return this.strategy.findAllNoteTypes();
    }
}
