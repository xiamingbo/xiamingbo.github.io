可以在pgadmin中直接执行代码块，类似如下：

DO
$$
BEGIN
   FOR i IN 1..250 LOOP
      INSERT INTO public.ip_pool(id, area, host_id, ip, status) VALUES (i, 'SH', -1, '200.200.201.'||i, 0);
   END LOOP;
END
$$
但是上述代码中，不能在END LOOP;语句之后加commit语句，原因如下：

不能在函数中使用SAVEPOINT,COMMIT或ROLLBACK等事务语句，在PL / pgSQL中启动块的BEGIN与启动事务的SQL语句BEGIN不同，只需从函数中删除COMMIT,就可以得到解决方案：因为整个函数总是在单个事务中运行,所以第三个语句中的任何错误都将导致ROLLBACK也撤消前两个语句.

如果加commit语句会报错如下：

ERROR:  cannot begin/end transactions in PL/pgSQL
HINT:  Use a BEGIN block with an EXCEPTION clause instead.
CONTEXT:  PL/pgSQL function inline_code_block line 6 at SQL statement
SQL state: 0A000
