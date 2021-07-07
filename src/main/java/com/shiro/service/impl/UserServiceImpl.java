package com.shiro.service.impl;

import com.shiro.bean.User;
import com.shiro.mapper.UserMapper;
import com.shiro.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    UserMapper userMapper;


    @Override
    public User findUserByName(String principal) {
        User user = userMapper.findUserByName(principal);
        return user;
    }

    @Override
    public List<String> getPermissions(User user) {

        return userMapper.getPermissions(user);
    }
}
