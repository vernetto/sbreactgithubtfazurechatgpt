package com.example.hello;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class SpaController {

    // serve index.html for root
    @GetMapping("/")
    public String root() {
        return "forward:/index.html";
    }

    // fallback for all client-side routes (only if no dot in path)
    @GetMapping("/**/{path:[^\\.]+}")
    public String forward() {
        return "forward:/index.html";
    }
}
