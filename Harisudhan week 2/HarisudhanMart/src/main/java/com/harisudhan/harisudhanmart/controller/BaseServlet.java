package com.harisudhan.harisudhanmart.controller;

import com.google.gson.Gson;
import com.harisudhan.harisudhanmart.dao.DAOFactory;
import com.harisudhan.harisudhanmart.dto.ApiResponse;
import com.harisudhan.harisudhanmart.listener.AppContextListener;
import java.io.BufferedReader;
import java.io.IOException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Shared helpers for every servlet in controller: JSON envelope writer (spec Section 13)
 * and DAOFactory access. Servlets stay thin — no SQL, no business logic (spec Section 2).
 */
public abstract class BaseServlet extends HttpServlet {

    protected static final Gson GSON = new Gson();

    protected DAOFactory daoFactory() {
        return new DAOFactory(AppContextListener.getDataSource());
    }

    protected void writeJson(HttpServletResponse resp, int status, Object data) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(GSON.toJson(ApiResponse.success(data)));
    }

    protected void writeError(HttpServletResponse resp, int status, String code, String message)
            throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(GSON.toJson(ApiResponse.error(code, message)));
    }

    protected String readBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = req.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        return sb.length() == 0 ? "{}" : sb.toString();
    }
}
