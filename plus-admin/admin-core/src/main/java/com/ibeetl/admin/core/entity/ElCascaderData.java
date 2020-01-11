package com.ibeetl.admin.core.entity;

import lombok.Data;
import lombok.NoArgsConstructor;

/** 前端级联器的数据格式类 */
@Data
@NoArgsConstructor
public class ElCascaderData {
  private Long id;
  private String label;
  private String value;
}
