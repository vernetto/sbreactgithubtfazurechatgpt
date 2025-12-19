package com.example.hello;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Makes refreshing on /some/path still return React index.html.
 * This keeps the app simple without adding extra libraries.
 */
@Configuration
public class SpaWebConfig implements WebMvcConfigurer {

  @Override
  public void addViewControllers(ViewControllerRegistry registry) {
    registry.addViewController("/{path:[^\\.]*}")
            .setViewName("forward:/index.html");
    registry.addViewController("/**/{path:[^\\.]*}")
            .setViewName("forward:/index.html");
  }

}
