package com.ibeetl.admin.core.conf;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.convert.Convert;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.ClassUtil;
import cn.hutool.core.util.EnumUtil;
import cn.hutool.core.util.ReflectUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.core.util.TypeUtil;
import cn.hutool.json.JSON;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.ibeetl.admin.core.annotation.RequestBodyPlus;
import com.ibeetl.admin.core.annotation.SnakeCaseParameter;
import com.ibeetl.admin.core.service.CoreUserService;
import com.ibeetl.admin.core.util.HttpRequestLocal;
import com.ibeetl.admin.core.util.JoseJwtUtil;
import com.ibeetl.admin.core.util.enums.DictTypeEnum;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Optional;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.beetl.core.GroupTemplate;
import org.beetl.ext.spring.BeetlGroupUtilConfiguration;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeansException;
import org.springframework.beans.PropertyAccessorFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.MethodParameter;
import org.springframework.core.ResolvableType;
import org.springframework.core.convert.TypeDescriptor;
import org.springframework.core.convert.converter.ConditionalGenericConverter;
import org.springframework.core.convert.converter.Converter;
import org.springframework.core.env.Environment;
import org.springframework.format.FormatterRegistry;
import org.springframework.format.datetime.DateFormatter;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.util.Assert;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.mvc.method.annotation.AbstractMessageConverterMethodProcessor;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter;

/** 切勿在此配置类中向SpringMVC中添加bean。 也就是不要 @Bean这类方法。 会出现无法ServletContext注入null，因为父接口的原因 */
@Configuration
public class SpringWebMvcConfigurer implements WebMvcConfigurer, InitializingBean {

  public static final String DEFAULT_APP_NAME = "开发平台";

  /** 系统名称,可以在application.properties中配置 app.name=xxx */
  //    @Value("${app.name}")
  //    String appName;

  private String mvcTestPath;

  @Autowired private Environment env;

  @Autowired private CoreUserService userService;

  @Autowired private BeetlGroupUtilConfiguration beetlGroupUtilConfiguration;

  @Autowired private GroupTemplate groupTemplate;

  @Autowired private RequestMappingHandlerAdapter adapter;

  /**
   * 添加拦截器
   *
   * @param registry 拦截器的注册器
   */
  @Override
  public void addInterceptors(InterceptorRegistry registry) {
    registry.addInterceptor(new HttpRequestInterceptor()).addPathPatterns("/**");
    registry
        .addInterceptor(new SessionInterceptor(userService))
        .excludePathPatterns("/user/login", "/error", "/user/logout")
        .addPathPatterns("/**");
  }

  /**
   * 增加跨域映射
   *
   * @param registry 跨域映射注册器
   */
  @Override
  public void addCorsMappings(CorsRegistry registry) {
    registry.addMapping("/**");
  }

  @Override
  public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
    //    resolvers.add(new UnderlineToCamelArgumentResolver());
  }

  /**
   * SpringMVC的请求响应消息的转换格式器
   *
   * @param registry
   */
  @Override
  public void addFormatters(FormatterRegistry registry) {
    registry.addFormatter(new DateFormatter("yyyy-MM-dd HH:mm:ss"));
    registry.addFormatter(new DateFormatter("yyyy-MM-dd"));
    registry.addConverter(
        new ConditionalGenericConverter() {
          @Override
          public boolean matches(TypeDescriptor sourceType, TypeDescriptor targetType) {
            boolean targetTypeMatches =
                Optional.ofNullable(targetType.getResolvableType())
                    .map(ResolvableType::resolve)
                    .map(resolvableType -> resolvableType.equals(Date.class))
                    .orElse(false);
            return targetTypeMatches;
          }

          @Override
          public Set<ConvertiblePair> getConvertibleTypes() {

            return CollUtil.newHashSet(
                new ConvertiblePair(String.class, Date.class),
                new ConvertiblePair(Long.class, Date.class));
          }

          @Override
          public Object convert(
              Object source, TypeDescriptor sourceType, TypeDescriptor targetType) {
            return DateUtil.date(Convert.toLong(source));
          }
        });
    registry.addConverter(
        new ConditionalGenericConverter() {
          /**
           * 处理从前端传递的字符串到对应的字典枚举，需要字典枚举类实现 {@link DictTypeEnum} 接口
           *
           * @return boolean
           */
          @Override
          public boolean matches(TypeDescriptor sourceType, TypeDescriptor targetType) {
            Class targetClass =
                Optional.ofNullable(targetType.getResolvableType())
                    .map(ResolvableType::resolve)
                    .orElse(null);
            return sourceType.getResolvableType().resolve().equals(String.class)
                && Enum.class.isAssignableFrom(targetClass)
                && DictTypeEnum.class.isAssignableFrom(targetClass);
          }

          @Override
          public Set<ConvertiblePair> getConvertibleTypes() {
            return CollUtil.newHashSet(new ConvertiblePair(String.class, DictTypeEnum.class));
          }

          @Override
          public Object convert(
              Object source, TypeDescriptor sourceType, TypeDescriptor targetType) {
            Class enumClass = targetType.getResolvableType().resolve();
            Map<String, Object> valueFieldMap = EnumUtil.getNameFieldMap(enumClass, "value");
            Set<Entry<String, Object>> entrySet = valueFieldMap.entrySet();
            String targetEnumName = StrUtil.EMPTY;
            for (Entry<String, Object> entry : entrySet) {
              if (entry.getValue().equals(source.toString())) {
                targetEnumName = entry.getKey();
                break;
              }
            }
            return EnumUtil.fromStringQuietly(enumClass, targetEnumName);
          }
        });
  }

  @Override
  public void afterPropertiesSet() {
    this.mvcTestPath = env.getProperty("mvc.test.path");
    Map<String, Object> var = new HashMap<>(5);
    String appName = env.getProperty("app.name");
    if (appName == null) {
      var.put("appName", DEFAULT_APP_NAME);
    }
    var.put("jsVer", System.currentTimeMillis());
    groupTemplate.setSharedVars(var);
    /*自定义参数解析器配置，自定义应该优先级最高*/
    List<HandlerMethodArgumentResolver> argumentResolvers = CollUtil.newArrayList();
    argumentResolvers.add(new RequestBodyPlusProcessor(adapter.getMessageConverters()));
    argumentResolvers.addAll(adapter.getArgumentResolvers());
    adapter.setArgumentResolvers(argumentResolvers);
  }
}

class HttpRequestInterceptor implements HandlerInterceptor {

  @Override
  public boolean preHandle(
      HttpServletRequest request, HttpServletResponse response, Object handler) {
    HttpRequestLocal.set(request);
    return true;
  }

  @Override
  public void afterCompletion(
      HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
    HttpRequestLocal.destory();
  }
}

class SessionInterceptor implements HandlerInterceptor {

  CoreUserService userService;

  public SessionInterceptor(CoreUserService userService) {
    this.userService = userService;
  }

  @Override
  public boolean preHandle(
      HttpServletRequest request, HttpServletResponse response, Object handler) {
    String token = HttpRequestLocal.getAuthorization();
    boolean isExpiration = JoseJwtUtil.verifyJwtJson(token);
    if (isExpiration) {
      /*验证失败，无效jwt*/
      return false;
    } else {
      token = JoseJwtUtil.refreshIssuedAtTime(token);
      response.setHeader(HttpHeaders.AUTHORIZATION, token);
    }
    return true;
  }
}

/** 自定义SpringMVC的controller方法的参数注解 {@link RequestBodyPlus} 的注入解析， 用json path 的方式注入json请求的参数 */
class RequestBodyPlusProcessor extends AbstractMessageConverterMethodProcessor {

  private static final ThreadLocal<String> bodyLocal = ThreadLocal.withInitial(() -> "{}");

  protected RequestBodyPlusProcessor(List<HttpMessageConverter<?>> converters) {
    super(converters);
  }

  @Override
  public boolean supportsParameter(MethodParameter parameter) {
    return parameter.hasParameterAnnotation(RequestBodyPlus.class);
  }

  @Override
  public Object resolveArgument(
      MethodParameter parameter,
      ModelAndViewContainer mavContainer,
      NativeWebRequest webRequest,
      WebDataBinderFactory binderFactory)
      throws Exception {
    parameter = parameter.nestedIfOptional();
    /*非json请求过滤*/
    Class<?> parameterClass = parameter.getNestedParameterType();
    if (!StrUtil.containsAny(
        webRequest.getHeader(HttpHeaders.CONTENT_TYPE), MediaType.APPLICATION_JSON_VALUE)) {
      return ReflectUtil.newInstanceIfPossible(parameterClass);
    }

    HttpServletRequest servletRequest = webRequest.getNativeRequest(HttpServletRequest.class);
    Assert.state(servletRequest != null, "No HttpServletRequest");
    ServletServerHttpRequest inputMessage = new ServletServerHttpRequest(servletRequest);

    StringHttpMessageConverter stringHttpMessageConverter = new StringHttpMessageConverter();

    String jsonBody;
    try {
      String readBody = stringHttpMessageConverter.read(String.class, inputMessage);
      /*每一个参数的注入都会读取一次输入流，但是request的输入流不可重复读，所以需要保持下来*/
      if (StrUtil.isBlank(readBody)) {
        jsonBody = bodyLocal.get();
      } else {
        bodyLocal.set(readBody);
        jsonBody = bodyLocal.get();
      }
    } catch (IOException e) {
      logger.error("Can't read request body by input stream : {}", e);
      jsonBody = bodyLocal.get();
    }

    RequestBodyPlus requestBodyPlus = parameter.getParameterAnnotation(RequestBodyPlus.class);
    JSON json = JSONUtil.parse(jsonBody);
    Object parseVal = json.getByPath(requestBodyPlus.value(), parameterClass);
    if (parseVal instanceof Map) {
      JSONObject jsonObject = JSONUtil.parseObj(parseVal);
      parseVal = JSONUtil.toBean(jsonObject, parameter.getNestedGenericParameterType(), true);
    } else if (parseVal instanceof List) {
      JSONArray jsonArray = JSONUtil.parseArray(parseVal);
      Type parameterType = TypeUtil.getTypeArgument(parameter.getNestedGenericParameterType());
      Class parameterTypeClass =
          null == parameterType ? Object.class : ClassUtil.loadClass(parameterType.getTypeName());
      parseVal = JSONUtil.toList(jsonArray, parameterTypeClass);
    }
    return parseVal;
  }

  @Override
  public boolean supportsReturnType(MethodParameter returnType) {
    return false;
  }

  @Override
  public void handleReturnValue(
      Object returnValue,
      MethodParameter returnType,
      ModelAndViewContainer mavContainer,
      NativeWebRequest webRequest) {}
}

/**
 * Class UnderlineToCamelArgumentResolver : <br>
 * 描述：处理请求参数的命名由下划线等转驼峰命名。<br>
 * 但是与另一个{@link DictTypeEnum} 枚举处理有冲突，所以交给前端处理命名转换
 *
 * @author 一日看尽长安花 Created on 2020/2/2
 */
class UnderlineToCamelArgumentResolver implements HandlerMethodArgumentResolver {
  /** 匹配下划线的格式 */
  private static Pattern pattern = Pattern.compile("_(\\w)");

  private static String underLineToCamel(String source) {
    Matcher matcher = pattern.matcher(source);
    StringBuffer sb = new StringBuffer();
    while (matcher.find()) {
      matcher.appendReplacement(sb, matcher.group(1).toUpperCase());
    }
    matcher.appendTail(sb);
    return sb.toString();
  }

  @Override
  public boolean supportsParameter(MethodParameter methodParameter) {
    return methodParameter.hasParameterAnnotation(SnakeCaseParameter.class);
  }

  @Override
  public Object resolveArgument(
      MethodParameter parameter,
      ModelAndViewContainer container,
      NativeWebRequest webRequest,
      WebDataBinderFactory binderFactory) {
    return handleParameterNames(parameter, webRequest);
  }

  private Object handleParameterNames(MethodParameter parameter, NativeWebRequest webRequest) {
    Object obj = BeanUtils.instantiateClass(parameter.getParameterType());
    BeanWrapper wrapper = PropertyAccessorFactory.forBeanPropertyAccess(obj);
    Iterator<String> paramNames = webRequest.getParameterNames();
    while (paramNames.hasNext()) {
      String paramName = paramNames.next();
      Object o = webRequest.getParameter(paramName);
      try {
        wrapper.setPropertyValue(underLineToCamel(paramName), o);
      } catch (BeansException e) {
      }
    }
    return obj;
  }
}
