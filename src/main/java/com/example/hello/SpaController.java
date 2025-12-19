package com.example.hello;

import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import java.io.InputStream;

@Controller
public class SpaController {

    @GetMapping(value = {"/", "/**/{path:[^\\.]+}"})
    @ResponseBody
    public ResponseEntity<Resource> index() {
        try {
            // We use the ClassLoader directly.
            // Do NOT use a leading slash here.
            InputStream is = getClass().getClassLoader().getResourceAsStream("static/index.html");

            if (is == null) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok()
                    .contentType(MediaType.TEXT_HTML)
                    .body(new InputStreamResource(is));
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}
