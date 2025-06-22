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
- 启动 app
  ```bash
  python manage.py runserver
  ```