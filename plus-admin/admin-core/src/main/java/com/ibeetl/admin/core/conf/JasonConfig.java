package com.ibeetl.admin.core.conf;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.convert.Convert;
import cn.hutool.core.util.EnumUtil;
import cn.hutool.core.util.ReflectUtil;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonParser.NumberType;
import com.fasterxml.jackson.core.JsonToken;
import com.fasterxml.jackson.core.Version;
import com.fasterxml.jackson.core.type.WritableTypeId;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.PropertyNamingStrategy.SnakeCaseStrategy;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitorWrapper;
import com.fasterxml.jackson.databind.jsontype.TypeSerializer;
import com.fasterxml.jackson.databind.module.SimpleModule;
import com.fasterxml.jackson.databind.ser.std.StdSerializer;
import com.ibeetl.admin.core.util.enums.DictTypeEnum;
import com.ibeetl.admin.core.web.JsonResult;
import java.io.IOException;
import java.lang.reflect.Type;
import java.text.SimpleDateFormat;
import org.beetl.sql.core.engine.PageQuery;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/** @author 一日看尽长安花 */
@Configuration
public class JasonConfig {
  @Bean
  @ConditionalOnMissingBean(ObjectMapper.class)
  public ObjectMapper getObjectMapper() {
    ObjectMapper objectMapper = new ObjectMapper();

    /*objectMapper.setDateFormat(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"));*/

    objectMapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
    objectMapper.setSerializationInclusion(Include.NON_NULL);

    objectMapper.configure(SerializationFeature.INDENT_OUTPUT, true);
    /*将date字段序列化为时间戳*/
    objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, true);
    /*map中date的也序列化为时间戳*/
    objectMapper.configure(SerializationFeature.WRITE_DATE_KEYS_AS_TIMESTAMPS, true);
    objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

    SimpleModule simpleModule = new SimpleModule("SimpleModule", Version.unknownVersion());

    simpleModule.addSerializer(JsonResult.class, new CustomJsonResultSerializer());
    simpleModule.addSerializer(DictTypeEnum.class, new DictTypeEnumSerializer());

    CustomLongSerializer longSerializer = new CustomLongSerializer();
    simpleModule.addSerializer(Long.class, longSerializer);
    simpleModule.addSerializer(Long.TYPE, longSerializer);

    objectMapper.registerModule(simpleModule);
    return objectMapper;
  }
}

class DictTypeEnumSerializer extends JsonSerializer<DictTypeEnum> {

  @Override
  public void serialize(DictTypeEnum value, JsonGenerator gen, SerializerProvider serializers)
      throws IOException {
    gen.writeStartObject();
    if (value instanceof Enum) {
      gen.writeObjectField("name", ReflectUtil.getFieldValue(value, "name"));
      gen.writeObjectField("value", ReflectUtil.getFieldValue(value, "value"));
      gen.writeObjectField("type", ReflectUtil.getFieldValue(value, "type"));
    }
    gen.writeEndObject();
  }
}

/**
 * 修正jackson转换Long类型的一个bug： jackson的转换Long类型时，如果数值在Integer范围，会变成Integer类型，然后通过强制转换为Long时就会报错。
 * 这里采用安全的Long转换避免强制类型转换
 */
class CustomLongSerializer extends StdSerializer<Object> {

  CustomLongSerializer() {
    super(Object.class);
  }

  @Override
  public void serialize(Object value, JsonGenerator gen, SerializerProvider provider)
      throws IOException {
    gen.writeNumber(Convert.toLong(value, null));
  }

  @Override
  public void serializeWithType(
      Object value, JsonGenerator g, SerializerProvider provider, TypeSerializer typeSer)
      throws IOException {
    WritableTypeId typeIdDef =
        typeSer.writeTypePrefix(g, typeSer.typeId(value, JsonToken.VALUE_NUMBER_INT));
    serialize(value, g, provider);
    typeSer.writeTypeSuffix(g, typeIdDef);
  }

  @Override
  public JsonNode getSchema(SerializerProvider provider, Type typeHint) {
    return createSchemaNode("long", true);
  }

  @Override
  public void acceptJsonFormatVisitor(JsonFormatVisitorWrapper visitor, JavaType typeHint)
      throws JsonMappingException {
    visitIntFormat(visitor, typeHint, NumberType.LONG);
  }
}

/**
 * layui 前端要求后台返回的数据格式
 *
 * @author xiandafu
 */
class CustomJsonResultSerializer extends JsonSerializer<JsonResult> {

  CustomJsonResultSerializer() {}

  /** 处理 JsonResult 返回结果。自动分离分页信息，不需要手动在controller中分离 */
  @Override
  public void serialize(JsonResult value, JsonGenerator gen, SerializerProvider serializers)
      throws IOException {
    gen.writeStartObject();
    gen.writeObjectField("code", Integer.parseInt(value.getCode()));
    gen.writeStringField("message", value.getMessage());
    Object data = value.getData();
    if (data instanceof PageQuery) {
      PageQuery query = (PageQuery) (data);
      /*不同js前端插件会有不一样数据格式，所以返回两种命名*/
      gen.writeNumberField("count", query.getTotalRow());
      gen.writeNumberField("total", query.getTotalRow());
      gen.writeObjectField("data", query.getList());
    } else {
      gen.writeObjectField("data", data);
    }
    gen.writeEndObject();
  }
}
