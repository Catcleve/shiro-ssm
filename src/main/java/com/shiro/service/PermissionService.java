package com.shiro.service;

import com.shiro.bean.Permission;

import java.util.List;

public interface PermissionService {
    List<Permission> queryByUserName(String userName);
}
