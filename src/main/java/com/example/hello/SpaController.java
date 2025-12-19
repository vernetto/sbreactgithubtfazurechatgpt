package com.example.hello;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.io.InputStream;

@RestController
public class SpaController {

    @GetMapping(value = {"/", "/**/{path:[^\\.]+}"})
    public void index(HttpServletResponse response) throws IOException {
        // Use ClassLoader directly to find the file inside BOOT-INF/classes/static/
        // Note: No leading slash here is often safer for strict ClassLoaders
        InputStream is = getClass().getClassLoader().getResourceAsStream("static/index.html");

        if (is == null) {
            response.sendError(404, "index.html not found in JAR");
            return;
        }

        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        // Stream the content directly to the response body
        StreamUtils.copy(is, response.getOutputStream());
    }
}
