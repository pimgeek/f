#!/usr/bin/ruby
# encoding: UTF-8

# 这个程序试图用 ruby 内置的 http server 实现 cgi 编程
# 调用程序的方法，运行以下命令
#   ruby -run -e httpd . -p 8000

# 001 最简单的例子
# 002 尝试打印中文字符
puts 'Content-type: text/plain'
puts
puts '你好，世界！' 

