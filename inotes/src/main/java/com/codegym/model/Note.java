package com.codegym.model;

import com.codegym.strategy.NoteStrategy;

public class Note {
    private int id;
    private String title;
    private String content;
    private int typeId;
    private NoteType noteType;

    // Tham chiếu chiến lược lưu trữ (Strategy) để gọi save(), delete() trực tiếp theo yêu cầu Bước 2
    private NoteStrategy strategy;

    public Note() {
    }

    public Note(String title, String content, int typeId) {
        this.title = title;
        this.content = content;
        this.typeId = typeId;
    }

    public Note(int id, String title, String content, int typeId) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.typeId = typeId;
    }

    public Note(int id, String title, String content, int typeId, NoteType noteType) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.typeId = typeId;
        this.noteType = noteType;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public NoteType getNoteType() {
        return noteType;
    }

    public void setNoteType(NoteType noteType) {
        this.noteType = noteType;
    }

    public void setStrategy(NoteStrategy strategy) {
        this.strategy = strategy;
    }

    public void save() {
        if (this.strategy != null) {
            this.strategy.save(this);
        }
    }

    public void delete(int id) {
        if (this.strategy != null) {
            this.strategy.delete(id);
        }
    }
}
