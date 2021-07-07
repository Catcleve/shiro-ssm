package com.shiro.service.impl;

import com.shiro.bean.Permission;
import com.shiro.mapper.PermissionMapper;
import com.shiro.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class PermissionServiceImpl implements PermissionService {

    @Autowired
    private PermissionMapper permissionMapper;

    @Override
    public List<Permission> queryByUserName(String userName) {

//        查出所有的权限
        List<Permission> allPermissions = permissionMapper.queryAll();

//        查出用户所拥有的权限
        List<Permission> permissions = permissionMapper.queryByUserName(userName);

//        遍历看是否有二级菜单
        for (Permission permission : permissions) {

            List<Permission> children = new ArrayList<>();

            for (Permission allPermission : allPermissions) {
                if (allPermission.getCode() == null) {
                    if (allPermission.getParentId().equals(permission.getPid())) {
                        children.add(allPermission);
                    }
                }
            }
            if (children.size() > 0) {
                permission.setChildren(children);
            }
        }

        return permissions;
    }
}
