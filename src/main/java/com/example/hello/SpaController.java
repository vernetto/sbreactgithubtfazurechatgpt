package com.example.hello;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class SpaController {

    @GetMapping(value = {"/", "/**/{path:[^\\.]+}"}, produces = MediaType.TEXT_HTML_VALUE)
    @ResponseBody
    public Resource index() {
        // This explicitly looks inside your JAR's /static/ folder
        // regardless of the OS working directory.
        return new ClassPathResource("static/index.html");
    }
}
