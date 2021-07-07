package com.shiro.mapper;

import com.shiro.bean.Permission;

import java.util.List;

public interface PermissionMapper {

    List<Permission> queryByUserName(String userName);

    List<Permission> queryAll();
}
