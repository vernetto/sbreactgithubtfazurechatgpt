package com.example.hello;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.GetMapping;

import java.io.IOException;
import java.io.InputStream;

@Controller
public class SpaController {

    @GetMapping(value = {"/", "/**/{path:[^\\.]+}"})
    public void index(HttpServletResponse response) throws IOException {
        // Access the file directly from the JAR classpath
        InputStream is = getClass().getClassLoader().getResourceAsStream("static/index.html");

        if (is == null) {
            response.sendError(404, "index.html not found in classpath");
            return;
        }

        // Manually set the content type because Spring's MIME detection is failing
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        // Stream the file content to the response
        StreamUtils.copy(is, response.getOutputStream());
    }
}