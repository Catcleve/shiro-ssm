package com.shiro.realm;

import com.shiro.bean.User;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.authc.FormAuthenticationFilter;
import org.apache.shiro.web.util.SavedRequest;
import org.apache.shiro.web.util.WebUtils;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import java.io.IOException;

public class MyFormAuthenticationFilter extends FormAuthenticationFilter {


//    解决用户未注销再次登录问题
    @Override
    protected boolean isAccessAllowed(ServletRequest request,
                                      ServletResponse response,
                                      Object mappedValue) {

        if (isLoginRequest(request, response))
        {
            if (isLoginSubmission(request, response))
            {
                //本次用户登陆账号
                String account = this.getUsername(request);
                Subject subject = this.getSubject(request, response);
                //之前登陆的用户
                User user = (User) subject.getPrincipal();
                //如果两次登陆的用户不一样，则先退出之前登陆的用户
                if (account != null && user != null && !account.equals(user.getUserName())) {
                    subject.logout();
                } else {
                    try {
                        //  如果是之前用户，直接到首页
                        request.getRequestDispatcher("/workbench/index").forward(request,response);
                    } catch (ServletException | IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
        return super.isAccessAllowed(request, response, mappedValue);
    }


//  解决登录后不跳转指定页面问题
    @Override
    protected boolean onLoginSuccess(AuthenticationToken token,
                                     Subject subject, ServletRequest request,
                                     ServletResponse response) throws Exception {

        //清空原有路径 跳转到下一个路径
        SavedRequest savedRequest = WebUtils.getAndClearSavedRequest(request);
        if(savedRequest!=null) {
            String requestUrl = savedRequest.getRequestUrl();
            System.out.println(requestUrl);
            //如果上一次请求路径为空 则跳转到登录成功页面
            if ("/".equals(requestUrl)) {
                WebUtils.redirectToSavedRequest(request, response, "/workbench/index");
            } else {
                //如果上一次请求正常 则直接重定向到上一次请求
                WebUtils.redirectToSavedRequest(request, response, requestUrl);
            }
        }else {
            WebUtils.redirectToSavedRequest(request, response, "/workbench/index");
        }
        return false;
    }
}
