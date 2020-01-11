package com.ibeetl.admin.console.web.query;

import static com.ibeetl.admin.core.util.enums.ElColumnType.DATE;
import static com.ibeetl.admin.core.util.enums.ElColumnType.DICT;
import static com.ibeetl.admin.core.util.enums.ElColumnType.STRING;

import com.ibeetl.admin.core.annotation.ElColumn;
import java.util.Date;
import lombok.Data;

/**
 * Class CoreUserElQuery : <br>
 * 描述：用户管理页面的metadata元数据
 *
 * @author 一日看尽长安花 Created on 2019/12/29
 */
@Data
public class CoreUserElQuery {

  @ElColumn(name = "ID", type = STRING)
  protected Long id;

  @ElColumn(name = "创建时间", type = DATE)
  protected Date createTime;

  @ElColumn(name = "用户名", type = STRING)
  private String code;

  @ElColumn(name = "姓名", type = STRING)
  private String name;

  @ElColumn(name = "状态", type = STRING)
  private String state;

  @ElColumn(name = "职务", type = DICT)
  private String jobType0;

  @ElColumn(name = "岗位", type = DICT)
  private String jobType1;
}
