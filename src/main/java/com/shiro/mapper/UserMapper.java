package com.shiro.mapper;

import com.shiro.bean.User;

import java.util.List;

public interface UserMapper {

    User findUserByName(String principal);

    List<String> getPermissions(User user);
}
