package com.rhdhv.frontend.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.rhdhv.demo.entity.Client;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Controller
public class WelcomeController {
    /*Options dropdown for html actions */
    List<String> listAction = Arrays.asList("Add", "Delete");
    // inject via application.properties
    @Value("${welcome.message}")
    private String message;

    @GetMapping("/")
    public String main(Model model) {
        model.addAttribute("message", message);
        Client client = new Client();
        model.addAttribute("client", client);
        model.addAttribute("listAction", listAction);
        /* Getting User list clients from backend service */
        List<Client> userList = getClients();
        model.addAttribute("userList", userList);
        return "welcome"; //view
    }

    // /hello?name=Java
    @GetMapping("/hello")
    public String mainWithParam(
            @RequestParam(name = "name", required = false, defaultValue = "") String name, Model model) {

        model.addAttribute("message", name);
        Client client = new Client();
        model.addAttribute("client", client);
        model.addAttribute("listAction", listAction);
        List<Client> userList = getClients();
        model.addAttribute("userList", userList);
        return "welcome"; //view
    }


}