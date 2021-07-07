package com.shiro.realm;

import com.shiro.bean.User;
import com.shiro.service.UserService;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.util.ByteSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class UserRealm extends AuthorizingRealm {



    @Autowired
    UserService userService;

    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principal) {

//        获取用户拥有的权限
        User user = (User) principal.getPrimaryPrincipal();
        List<String> PermissionCodes =  userService.getPermissions(user);

        SimpleAuthorizationInfo authenticationInfo = new SimpleAuthorizationInfo();
        authenticationInfo.addStringPermissions(PermissionCodes);
        return authenticationInfo;
    }

    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authenticationToken) throws AuthenticationException {

//        获取用户名
        String principal = (String) authenticationToken.getPrincipal();
//        通过用户名查询密码
        User user = userService.findUserByName(principal);
//        如果查不到，说明账号错误，返回null
        if (user == null) {
            return null;
        }
//        查得到生产令牌，返回
        return new SimpleAuthenticationInfo(user,user.getPassWord(),
                ByteSource.Util.bytes(user.getSalt()),"UserRealm");
    }
}
