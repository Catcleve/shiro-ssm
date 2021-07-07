package com.shiro.bean;

import lombok.Data;

import java.util.List;

@Data
public class Permission {

  private String pid;
  private String pName;
  private String url;
  private String parentId;
  private String code;
  private List<Permission> children;

}
