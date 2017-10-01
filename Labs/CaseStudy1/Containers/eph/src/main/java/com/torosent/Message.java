package com.torosent;

import java.util.UUID;

public class Message {
        public Message() {
            UUID uuid = UUID.randomUUID();
            id = uuid.toString();
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    private String id;
    private String message;
}
