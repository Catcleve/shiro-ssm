# shiro整合到ssm练习

## 一，建立关系表 一共五张

|              |                          |
| :----------: | :----------------------: |
|    用户表    |        要登录的表        |
|    角色表    | 不同的角色对应不同的权限 |
|    权限表    | 不同的权限可以做不同的事 |
| 用户--角色表 |      用户对应的角色      |
| 角色--权限表 |      角色对应的权限      |

## 二，导入依赖

###### 放入整个依赖，方便使用

```xml
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>org.example</groupId>
  <artifactId>shiro-ssm</artifactId>
  <version>1.0-SNAPSHOT</version>
  <packaging>war</packaging>

  <name>shiro-ssm Maven Webapp</name>
  <!-- FIXME change it to the project's website -->
  <url>http://www.example.com</url>

  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <maven.compiler.source>1.7</maven.compiler.source>
    <maven.compiler.target>1.7</maven.compiler.target>
  </properties>

<!--版本管理-->
  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-framework-bom</artifactId>
        <version>5.2.7.RELEASE</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>

  <dependencies>

<!--      日志依赖-->
    <dependency>
      <groupId>org.slf4j</groupId>
      <artifactId>slf4j-api</artifactId>
      <version>1.7.5</version>
    </dependency>
    <dependency>
      <groupId>org.slf4j</groupId>
      <artifactId>slf4j-log4j12</artifactId>
      <version>1.7.5</version>
    </dependency>

<!--      测试-->
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.11</version>
      <scope>test</scope>
    </dependency>

<!--      spring核心-->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-context</artifactId>
    </dependency>

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-jdbc</artifactId>
    </dependency>

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-webmvc</artifactId>
    </dependency>

<!--      mybatis-->
    <dependency>
      <groupId>org.mybatis</groupId>
      <artifactId>mybatis</artifactId>
      <version>3.5.7</version>
    </dependency>

    <dependency>
      <groupId>org.mybatis</groupId>
      <artifactId>mybatis-spring</artifactId>
      <version>2.0.6</version>
    </dependency>

<!--      mysql数据库-->
    <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-java</artifactId>
      <version>8.0.25</version>
    </dependency>

<!--      连接数据库-->
    <dependency>
      <groupId>commons-dbcp</groupId>
      <artifactId>commons-dbcp</artifactId>
      <version>1.4</version>
    </dependency>

<!--      fastjson-->
    <dependency>
      <groupId>com.alibaba</groupId>
      <artifactId>fastjson</artifactId>
      <version>1.2.3</version>
    </dependency>

    <!--jstl-->
    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>jsp-api</artifactId>
      <version>2.0</version>
      <scope>runtime</scope>
    </dependency>

    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>jstl</artifactId>
      <version>1.2</version>
    </dependency>

    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>servlet-api</artifactId>
      <version>2.3</version>
      <scope>provided</scope>
    </dependency>

    <dependency>
      <groupId>org.projectlombok</groupId>
      <artifactId>lombok</artifactId>
      <version>1.18.0</version>
      <scope>provided</scope>
    </dependency>

    <dependency>
      <groupId>cn.hutool</groupId>
      <artifactId>hutool-all</artifactId>
      <version>5.7.2</version>
    </dependency>

    <dependency>
      <groupId>javax.annotation</groupId>
      <artifactId>javax.annotation-api</artifactId>
      <version>1.3.2</version>
    </dependency>

    <!--AspectJ-->
    <dependency>
      <groupId>org.aspectj</groupId>
      <artifactId>aspectjweaver</artifactId>
      <version>1.6.8</version>
    </dependency>

<!--shiro-->
    <dependency>
      <groupId>org.apache.shiro</groupId>
      <artifactId>shiro-web</artifactId>
      <version>1.7.1</version>
    </dependency>

    <dependency>
      <groupId>org.apache.shiro</groupId>
      <artifactId>shiro-spring</artifactId>
      <version>1.7.1</version>
    </dependency>
  </dependencies>
</project>

```

###### 在web.xml添加

```xml
  <filter>
    <filter-name>shiroFilter</filter-name>
    <filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
    <init-param>
      <!--设置成true:由Servlet容器管理过滤器的生命周期-->
      <param-name>targetFilterLifecycle</param-name>
      <param-value>true</param-value>
    </init-param>
    <!--设置Spring容器的filter的bean的id,如果不设置，默认以filter-name的
    值尾bean的id号-->
    <init-param>
      <param-name>targetBeanName</param-name>
      <param-value>shiroFilter</param-value>
    </init-param>
  </filter>
  <filter-mapping>
    <filter-name>shiroFilter</filter-name>
    <url-pattern>/*</url-pattern>
  </filter-mapping>
```

配置spring-shiro.xml文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

<!--    ShiroFilterFactoryBean-->
    <bean id="shiroFilter" class="org.apache.shiro.spring.web.ShiroFilterFactoryBean">
<!--注入securityManager-->
        <property name="securityManager" ref="securityManager"/>
<!--        登录失败后跳转的url-->
        <property name="loginUrl" value="/user/login"/>
<!--        自定义各种过滤器-->
        <property name="filters">
            <map>
                <entry key="authc" value-ref="formAuthenticationFilter"/>
                <entry key="logout" value-ref="logoutFilter"/>
            </map>
        </property>
<!--        验证通过之后跳转的页面-->
        <property name="successUrl" value="/workbench/index"/>
<!--        授权失败跳转的页面-->
        <property name="unauthorizedUrl" value="/unauthorized"/>
<!--        过滤器和对应的地址-->
        <property name="filterChainDefinitions">
            <value>
                /jquery/** = anon
                /image/** = anon
                /index.jsp = anon
                /user/logout = logout
                /** = authc
            </value>
        </property>
    </bean>
<!--    自定义formAuthenticationFilter，可以修改username和password-->
    <bean id="formAuthenticationFilter" class="org.apache.shiro.web.filter.authc.FormAuthenticationFilter">
<!--        <property name="usernameParam" value="xxx"/>-->
    </bean>

<!--    自定义登出过滤器配置-->
    <bean id="logoutFilter" class="org.apache.shiro.web.filter.authc.LogoutFilter">
<!--        配置登出后重定向的地址-->
        <property name="redirectUrl" value="/user/login"/>
    </bean>
    
    <!--    securityManager对象，上面需要用-->
    <bean id="securityManager" class="org.apache.shiro.web.mgt.DefaultWebSecurityManager">
        <property name="realms">
            <list>
                <ref bean="userRealm"/>
            </list>
        </property>
    </bean>

<!--    realm，重写的userRealm对象-->
    <bean id="userRealm" class="com.shiro.realm.UserRealm">
        <property name="credentialsMatcher">
            <bean class="org.apache.shiro.authc.credential.HashedCredentialsMatcher">
                <property name="hashAlgorithmName" value="md5"/>
                <property name="hashIterations" value="5"/>
            </bean>
        </property>
    </bean>
</beans>
```



###### 各种过滤器属性

|  配置  |        **对应的过滤器**        | **功能**                                                     |
| :----: | :----------------------------: | :----------------------------------------------------------- |
|  anon  |        AnonymousFilter         | 指定url可以匿名访问                                          |
| authc  |    FormAuthenticationFilter    | 基于表单的拦截器；如“/**=authc”，如果没有登录会跳到相应的登录页面登录；主要属性：usernameParam：表单提交的用户名参数名（   username）； passwordParam：表单提交的密码参数名（password）； rememberMeParam：表单提交的密码参数名（rememberMe）； loginUrl：登录页面地址（/login.jsp）；successUrl：登录成功后的默认重定向地址；   failureKeyAttribute：登录失败后错误信息存储key（shiroLoginFailure） |
| logout |          LogoutFilter          | 退出拦截器，主要属性：redirectUrl：退出成功后重定向的地址（/） |
|  user  |           UserFilter           | 用户拦截器，用户已经身份验证/记住我登录的都可                |
| perms  | PermissionsAuthorizationFilter | 角色授权拦截器，验证用户是否拥有所有角色；主要属性： loginUrl：登录页面地址（/login.jsp）；unauthorizedUrl：未授权后重定向的地址；示例“/admin/**=roles[admin]” |

# 授权管理

### 一，使用配置文件实现授权管理

```xml
<!--        授权失败跳转的页面-->
        <property name="unauthorizedUrl" value="/unauthorized"/>
<!--        过滤器和对应的地址-->
        <property name="filterChainDefinitions">
            <value>
                /jquery/** = anon
                /image/** = anon
                /index.jsp = anon
                /user/logout = logout
                <!--       这一行对应的是授权管理-->
<!--                /workbench/activity/add = perms[activity:add]-->
                /** = authc
            </value>
        </property>

```

#### 访问/workbench/activity/add就会触发授权管理（当然是在登录之后）， 会跳转到之前重写的授权方法中

```java
   //授权验证
	@Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principal) {

//        获取用户拥有的权限
        User user = (User) principal.getPrimaryPrincipal();
        // 注意集合不要有重复的，不能有空，不然会授权失败，所以最好用set，做非空排除
        List<String> PermissionCodes =  userService.getPermissions(user);
        SimpleAuthorizationInfo authenticationInfo = new SimpleAuthorizationInfo();
        authenticationInfo.addStringPermissions(PermissionCodes);
        return authenticationInfo;
    }

```

#### 如果授权成功，会放行，也就是会到controller对应的方法 ,没有权限，到指定的地址

##### 例：

​	前端使用ajax访问

```js
$.post('/shiro/workbench/activity/add', function (data) {
            if (data) {
                layer.msg("有权限");
            } else {
                layer.msg("无权限")
            }
        }, 'json'); 
```

​		登陆后 访问 /workbench/activity/add

​		shiro过滤器  /workbench/activity/add = perms[activity:add]

​		发现有符合条件的过滤器perms 进入自定义的realm中

​		获取用户，拿用户的权限对比定义的权限

##### 有权限：访问controller中的 /workbench/activity/add

```java
    @RequestMapping("/workbench/activity/add")
    @ResponseBody
    public boolean add (){

        return true;
    }
```





##### 无权限：访问shiro中定义的地址 <property name="unauthorizedUrl" value="/unauthorized"/>

```java
   	@RequestMapping("/unauthorizedUrl")
    @ResponseBody
    public boolean unauthorizedUrl (){

        return false;
    }
```

### 二，使用注解进行授权管理

#### springmvc.xml文件添加配置

```xml
<!--开启AOP代理功能-->
<aop:config proxy-target-class="true" />

<!--开启shiro注解-->
<bean class="org.apache.shiro.spring.security.interceptor.AuthorizationAttributeSourceAdvisor">
    <property name="securityManager" ref="securityManager" />
</bean>
```

##### 在需要授权管理的方法上添加注解@RequiresPermissions

```java
    @RequestMapping("/workbench/activity/add")
    @ResponseBody
    @RequiresPermissions("activity:add")
    public boolean add (){
        return true;
    }
```

##### 有权限放行执行方法中的代码，没有权限则会抛出异常，所以需要配置异常映射

##### 也是在spirngmvc.xml中

```xml
    <bean class="org.springframework.web.servlet.handler.SimpleMappingExceptionResolver">
        <property name="exceptionMappings">
            <props>
                <prop key="org.apache.shiro.authz.UnauthorizedException">
                    <!--这里填写需要跳转的视图地址，例如填写 xxx 会跳转到 项目WEB-INFO/xxx.jsp-->
                    <!--跟视图解析器配合使用-->
                </prop>
            </props>
        </property>
    </bean>
```

### 三，配合ajax异步请求使用的问题

##### 使用注解进行授权管理时，因为会抛出异常然后跳转视图，所以使用ajax会导致没有返回值的问题，需要修改前端代码

```js
$.ajax({
    url: '/shiro/workbench/activity/add',
    type: 'post',
    dataType: 'json',
    success: function () {
        $("#createActivityModal").modal('show')
        layer.msg("有权限");
    },
    //		如果授权未通过，会返回404，说明没有权限，所以使用error可以判定没有权限
    error:function () {
        layer.msg("无权限")
        //禁用对应的按钮
        $("#createBtn").attr("disabled","disabled")
    }
})
```

# shiro使用中出现的问题及解决办法

### 一，登陆后跳转到“/”而不是指定页面

通常我们使用shiro，登录之后就会跳到我们上一次访问的URL，如果我们是直接访问登录页面的话，shiro就会根据我们配置的successUrl去重定向，如果我们没有配置successUrl的话，那么shiro重定向默认的/，这个逻辑看shiro的源码就可以知道。所以如果说你上一次的访问路径为空那下一次登录重定向地址默认的"/"，则会出现登录成功后界面跳转到icon小绿叶界面。我们需要定义一个类来处理路径若为空的结果。

 

1.shiro会把请求信息保存到session中：

2.然后判断是否已经登录，如果没有登录，就会跳到登录页面，用户输入凭证之后就会交给FormAuthenticationFilter这个类来处理；

3.如果登录成功之后就会调用重定向

4.shiro去session中找出之前的保存的请求，如果没有的话就会跳转到我们配置的successUrl！

但是现实中往往有很多需求就是，要求我们登录成功之后要跳到一个固定的页面，通常是跳到首页，那这时候我们应该怎么做呢？

通过查看源码，我发现在shiro的webUtils工具类中有这样一个方法：

我们可以定义MyFormAuthziction 类重写登录方法，继承FormAuthenticationFilter 这个类

```java
package com.jk.shiro;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.authc.FormAuthenticationFilter;
import org.apache.shiro.web.util.SavedRequest;
import org.apache.shiro.web.util.WebUtils;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
public class MyFormAuthziction extends FormAuthenticationFilter {

    /**
     * 重写登录成功方法
     * @param token
     * @param subject
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @Override
    protected boolean onLoginSuccess(AuthenticationToken token, Subject subject, ServletRequest request, ServletResponse response) throws Exception {

        //清空原有路径 跳转到下一个路径
        SavedRequest savedRequest = WebUtils.getAndClearSavedRequest(request);
        if(savedRequest!=null) {
            String requestUrl = savedRequest.getRequestUrl();
            System.out.println(requestUrl);
            //如果上一次请求路径为空 则跳转到登录成功页面
            if ("/".equals(requestUrl)) {
                WebUtils.redirectToSavedRequest(request, response, "/index");
            } else {
                //如果上一次请求正常 则直接重定向到上一次请求
                WebUtils.redirectToSavedRequest(request, response, requestUrl);
            }
        }else {
            WebUtils.redirectToSavedRequest(request, response, "/index");
        }
        return false;
    }
}

```



这样，就实现了在交给shiro处理重定向的时候清理了session中保存的请求信息，这样的话，就可以我们指定的url传递进去，这样就实现了跳转到我们指定的页面；

 

 

其次，要把我们定义的过滤器配置一下，你的配置类(ShiroConfig)里需要修改默认核心过滤器  authc

        //修改默认核心过滤器 authc
        Map<String, Filter> filterMap = new HashMap<String, Filter>();
        filterMap.put("authc", new MyFormAuthziction());
        shiroFilterFactoryBean.setFilters(filterMap);
这样就完成了，我们每次登录成功都会跳转到你指定的主页面！

原文链接：https://blog.csdn.net/SpringCYB/article/details/88979642

### 二，用户不注销再次登录无反应的问题

问题：第一次使用shiro时，做好登录功能（包括用户检验等），并且登录成功以后，为了方便直接修改浏览器的地址返回到登录页面（即没有注销登录），当输入另一个用户的账号和密码后跳转到登录成功页面还是显示先前登录的用户信息

原因：一步步debug下去以后就很容易发现问题了，登录验证前会经过AuthenticationFilter类的isAccessAllowed方法，如果该方法返回true的话就不会执行下面的登陆验证了，该方法如下：


知道这个以后解决方法就很简单了，只要重写该类或该子类的的isAccessAllowed方法就可以了，这里我重写了子类FormAuthenticationFilter

```java
protected boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object mappedValue) {
        Subject subject = getSubject(request, response);
        //返回subject是否已经登陆验证通过了，因为没有logout，所以返回true
        return subject.isAuthenticated();
    }

```


```java
@Override
protected boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object mappedValue) {

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
```

最后再配置文件中注册该类的解决了！ 

原文链接：https://blog.csdn.net/qq_27273089/article/details/63684557