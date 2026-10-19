package com.codegym.controller;

import com.codegym.model.Note;
import com.codegym.model.NoteType;
import com.codegym.service.NoteManagement;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "NoteServlet", urlPatterns = "/notes")
public class NoteServlet extends HttpServlet {

    private NoteManagement getNoteManagement(HttpServletRequest request) {
        HttpSession session = request.getSession();
        NoteManagement manager = (NoteManagement) session.getAttribute("noteManagement");
        if (manager == null) {
            manager = new NoteManagement();
            session.setAttribute("noteManagement", manager);
        }
        return manager;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        NoteManagement manager = getNoteManagement(request);
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "create":
                showCreateForm(request, response, manager);
                break;
            case "edit":
                showEditForm(request, response, manager);
                break;
            case "delete":
                showDeleteForm(request, response, manager);
                break;
            case "view":
                viewNote(request, response, manager);
                break;
            case "search":
                searchNotes(request, response, manager);
                break;
            case "switch-storage":
                switchStorage(request, response, manager);
                break;
            default:
                listNotes(request, response, manager);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        NoteManagement manager = getNoteManagement(request);
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "create":
                createNote(request, response, manager);
                break;
            case "edit":
                updateNote(request, response, manager);
                break;
            case "delete":
                deleteNote(request, response, manager);
                break;
            default:
                response.sendRedirect("notes");
                break;
        }
    }

    private void listNotes(HttpServletRequest request, HttpServletResponse response, NoteManagement manager) throws ServletException, IOException {
        List<Note> notes = manager.getAllNotes();
        request.setAttribute("notes", notes);
        attachStorageInfo(request, manager);
        RequestDispatcher dispatcher = request.getRequestDispatcher("note/list.jsp");
        dispatcher.forward(request, response);
    }

    private void searchNotes(HttpServletRequest request, HttpServletResponse response, NoteManagement manager) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Note> notes = manager.searchNotes(keyword);
        request.setAttribute("notes", notes);
        request.setAttribute("keyword", keyword);
        attachStorageInfo(request, manager);
        RequestDispatcher dispatcher = request.getRequestDispatcher("note/list.jsp");
        dispatcher.forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response, NoteManagement manager) throws ServletException, IOException {
        List<NoteType> noteTypes = manager.getAllNoteTypes();
        request.setAttribute("noteTypes", noteTypes);
        attachStorageInfo(request, manager);
        RequestDispatcher dispatcher = request.getRequestDispatcher("note/create.jsp");
        dispatcher.forward(request, response);
    }

    private void createNote(HttpServletRequest request, HttpServletResponse response, NoteManagement manager) throws IOException {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        int typeId = 1;
        try {
            typeId = Integer.parseInt(request.getParameter("typeId"));
        } catch (NumberFormatException ignored) {
        }

        manager.addNote(title, content, typeId);
        response.sendRedirect("notes");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response, NoteManagement manager) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Note note = manager.getNoteById(id);
        if (note == null) {
            response.sendRedirect("notes");
            return;
        }

        List<NoteType> noteTypes = manager.getAllNoteTypes();
        request.setAttribute("note", note);
        request.setAttribute("noteTypes", noteTypes);
        attachStorageInfo(request, manager);
        RequestDispatcher dispatcher = request.getRequestDispatcher("note/edit.jsp");
        dispatcher.forward(request, response);
    }

    private void updateNote(HttpServletRequest request, HttpServletResponse response, NoteManagement manager) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        int typeId = 1;
        try {
            typeId = Integer.parseInt(request.getParameter("typeId"));
        } catch (NumberFormatException ignored) {
        }

        manager.updateNote(id, title, content, typeId);
        response.sendRedirect("notes");
    }

    private void showDeleteForm(HttpServletRequest request, HttpServletResponse response, NoteManagement manager) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Note note = manager.getNoteById(id);
        if (note == null) {
            response.sendRedirect("notes");
            return;
        }

        request.setAttribute("note", note);
        attachStorageInfo(request, manager);
        RequestDispatcher dispatcher = request.getRequestDispatcher("note/delete.jsp");
        dispatcher.forward(request, response);
    }

    private void deleteNote(HttpServletRequest request, HttpServletResponse response, NoteManagement manager) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        manager.deleteNote(id);
        response.sendRedirect("notes");
    }

    private void viewNote(HttpServletRequest request, HttpServletResponse response, NoteManagement manager) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Note note = manager.getNoteById(id);
        if (note == null) {
            response.sendRedirect("notes");
            return;
        }

        request.setAttribute("note", note);
        attachStorageInfo(request, manager);
        RequestDispatcher dispatcher = request.getRequestDispatcher("note/view.jsp");
        dispatcher.forward(request, response);
    }

    private void switchStorage(HttpServletRequest request, HttpServletResponse response, NoteManagement manager) throws IOException {
        String type = request.getParameter("type");
        manager.switchStrategy(type);
        response.sendRedirect("notes");
    }

    private void attachStorageInfo(HttpServletRequest request, NoteManagement manager) {
        request.setAttribute("currentStorageType", manager.getCurrentStrategyType());
        request.setAttribute("currentStorageName", manager.getCurrentStrategyName());
    }
}
