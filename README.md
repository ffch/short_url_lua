# 短链接 #
## ngx_lua版本 ##
- **执行sql语句**<br>
建表，短链接要入库，id是seq序增

- **生成短链接**<br>
http://127.0.0.1:90/gen?url=http://www.jcodecraeer.com/a/anzhuokaifa/androidkaifa/2015/0106/2275.html
生成之后，显示的信息中，surl即是短链接。这里，get请求时url如果有=&？要做转义。否则url取不完全

- **访问短链接**<br>
http://127.0.0.1:90/0002
自动跳转到输入的url
