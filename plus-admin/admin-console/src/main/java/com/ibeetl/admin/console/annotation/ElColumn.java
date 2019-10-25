package com.ibeetl.admin.console.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 前端 element-ui 中的数据表格与vo对象字段对应的元数据信息的注解
 *
 * @author 一日看尽长安花
 */
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
public @interface ElColumn {

  /**
   * 数据表格中的列名称
   *  @return
   *  */
  String name();

  /**
   * 该列的类型。{@link }
   * @return
   * */
  String type();

  /**
   * 增加数据表格的手动排序
   *  @return
   *  */
  boolean sortable() default false;

  /**  @return */
  boolean visible() default true;

  boolean required() default false;
}
