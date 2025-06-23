<h2 align="center"> 猎鹰 </h2>

### 表结构（待完善）
![](./image/lieying.png)

### 运行猎鹰
- 在 `lieying/.env` 中修改数据库配置
- 将表结构迁移到 MySQL 数据库中
  ```bash
  python manage.py makemigrations
  python manage.py migrate
  ```
- 导入测试数据
  ```bash
  USE lieying;
  source lieying.sql;
  ```
- 创建超级管理员，并在 [127.0.0.1:8000/admin](http://127.0.0.1:8000/admin) 登录 
  ```bash
  python manage.py createsuperuser
  ```
- 启动 app
  ```bash
  python manage.py runserver
  ```