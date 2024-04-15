package com.dietideals24.DietiDeals24.entity;

public class AuthenticationResponse {
    private String token;

    public AuthenticationResponse(String token){
        this.token = token;
    }

    public String getToken(){
        return token;
    }
}
