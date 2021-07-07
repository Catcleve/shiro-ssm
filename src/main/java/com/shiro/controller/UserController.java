package com.shiro.controller;

import cn.hutool.core.util.StrUtil;
import com.shiro.bean.Permission;
import com.shiro.bean.User;
import com.shiro.service.PermissionService;
import com.shiro.service.UserService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class UserController {


    @Autowired
    private UserService userService;

    @Autowired
    private PermissionService permissionService;

    @RequestMapping("user/login")
    public String login(HttpServletRequest request){

        String exception = (String) request.getAttribute("shiroLoginFailure");
        if (StrUtil.contains(exception,"UnknownAccountException")) {
            request.setAttribute("message","账号错误");
        } else if (StrUtil.contains(exception,"IncorrectCredentialsException")) {
            request.setAttribute("message","密码错误");
        }
        return "../index";
    }

    @RequestMapping("workbench/index")
    public String toIndex (HttpSession session){

        User user = (User) SecurityUtils.getSubject().getPrincipal();

        List<Permission> permissions = permissionService.queryByUserName(user.getUserName());

        user.setPermissions(permissions);

        session.setAttribute("user",user);

        return "/workbench/index";
    }



    @RequestMapping("/workbench/activity/add")
    @ResponseBody
    @RequiresPermissions("activity:add")
    public boolean add (){

        return true;
    }

/*    @RequestMapping("/user/unauthorizedUrl")
    @ResponseBody
    public boolean unauthorizedUrl (){

        return false;
    }*/
}
