package com.shiro.service;

import com.shiro.bean.User;

import java.util.List;

public interface UserService {
    User findUserByName(String principal);

    List<String> getPermissions(User user);
}
