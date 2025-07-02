<h2 align="center"> 猎鹰 </h2>

- [表结构（待完善）](#表结构待完善)
- [数据库配置](#数据库配置)
- [打分模块配置（本地测试可跳过）](#打分模块配置本地测试可跳过)
- [运行方式](#运行方式)
- [猎鹰开发](#猎鹰开发)
  - [新建网页（功能）方法](#新建网页功能方法)


### 表结构（待完善）
![](./image/lieying.png)


### 数据库配置
- 新建`lieying/.env` ，修改对应数据库配置（参考 `.env.example` 模板）
- 将表结构迁移到 MySQL 数据库中
  ```bash
  python manage.py makemigrations
  python manage.py migrate
  ```
- 导入测试数据
  ```bash
  mysql -u <user> -p; # 登录 MySQL 服务器
  source lieying.sql; # 导入数据
  ```

### 打分模块配置（本地测试可跳过）
- 启动 redis 和 celery
  ```bash
  ./scripts/start_redis.sh && ./scripts/restart_celery.sh
  ```
- 在 `settings.py` 中修改模型地址 `MATCHER_MODEL_PATH`

### 运行方式

- 启动 app，并注册一个用户
  ```bash
  python manage.py runserver
  ```
### 猎鹰开发
#### 新建网页（功能）方法
1. 找到你要新建页面的对应app（假设为myapp），以下无特别说明均在该路径。 
2. 在 `templates/myapp` 下创建 HTML 模板，继承 `base.html`（如果需要），这里前面加一个myapp主要是为了区分，你也可以改成你喜欢的名字。
3. 在 `views.py` 中添加视图函数，注意连接到`myapp/xx.html`
4. 在 `urls.py` 的 `urlpatterns` 中注册对应路径
5. 如果`lieying/urls.py`里面没有`include("myapp.urls")`你还需添加之（更深层次，如果你没在settings注册记得先注册）。

页面之间链接跳转方式：
```html
<a href="{% url '视图名' 参数 %}">显示文字</a>
```