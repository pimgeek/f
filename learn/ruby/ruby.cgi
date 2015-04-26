#!/usr/bin/ruby

# 这个程序试图用 ruby 内置的 http server 实现 cgi 编程
# 调用程序的方法，运行以下命令
#   ruby -run -e httpd . -p 8000

# 001 最简单的例子
puts 'Content-type: text/plain'
puts
puts 'Hello, World! ' 

