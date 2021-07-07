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
                <!--       这一行对应的事授权管理-->
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
        // 注意集合不要又重复的，不能有空，不然会授权失败，所以最好用set，做非空排除
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

