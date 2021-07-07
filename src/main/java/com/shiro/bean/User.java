package com.shiro.bean;

import lombok.Data;

import java.util.List;

@Data
public class User {

    private String uId;
    private String userName;
    private String passWord;
    private String salt;
    private List<Permission> permissions;
}
