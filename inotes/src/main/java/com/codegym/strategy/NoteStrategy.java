package com.codegym.strategy;

import com.codegym.model.Note;
import com.codegym.model.NoteType;

import java.util.List;

public interface NoteStrategy {
    void save(Note note);

    void delete(int id);

    List<Note> findAll();

    List<Note> search(String keyword);

    Note findById(int id);

    List<NoteType> findAllNoteTypes();

    String getStrategyName();
}
