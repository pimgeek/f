#!/usr/bin/ruby
# encoding: UTF-8

# 这个程序试图用 ruby 内置的 http server 实现 cgi 编程
# 调用程序的方法，运行以下命令
#   ruby -run -e httpd . -p 8000
# 注意：ruby 脚本文件必须以 cgi 为扩展名，
# 不然会被当做静态网页直接打印出来

# 001 最简单的例子
# 002 尝试打印中文字符
# 003 引入 'cgi' 模块

require 'cgi'

cgi = CGI.new

puts cgi.header
puts '<h1>你好，世界！</h1>' 

