package com.rhdhv.frontend.entity;
public class Client {
    /*Class used to mapping data clients (name and ID)
    * To the WelcomeController.java and welcome.html */

    private long id;
    private String name;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }


    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    private String action;
}