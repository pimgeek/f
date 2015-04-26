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
# 004 尝试利用 cgi 模块读取网页的查询参数
# 注意：如果需要在字符界面下操作，要用 Ctrl+D 提交
# 005 尝试利用 cgi 模块读取网页查询参数的所有变量名
# 006 创建一个新的表单 form.html 用来输入查询参数的值

require 'cgi'
require 'htmlentities'
require 'orchestrate'

# 创建 cgi 对象，获取网页输入
cgi = CGI.new('html4')
params = cgi.params

# 创建 htmlentities 对象
coder = HTMLEntities.new

# 使用 Orchestrate::Client 方式调用
host = 'https://api.ctl-sg1-a.orchestrate.io'
api_key = '19efed2d-c8fa-465a-a7d5-eb424e15b356'
coll_name = :mpe_orig
key = params['key'][0].to_sym
hidden_key = :content
val = params['val'][0]

# 使用 Orchestrate::Application 方式调用
app = Orchestrate::Application.new(api_key, host)

# 尝试访问（不存在就创建）一个带名称的 collection
coll_obj = app[coll_name]

# 提交数据到 orchestra 服务器
if (key != '')
  kv = coll_obj.set(key,
    { hidden_key => val }
  )
end

# 把结果页面打印到浏览器
cgi.out {
  cgi.html {
    cgi.head { "\n" + cgi.title {"数据提交结果"} }
    cgi.body { "\n" \
      + cgi.h1 { "执行数据提交操作" } \
      + cgi.h3 { "记忆钩子: " + key.to_s } \
      + cgi.h3 { "内容主体: " + val } \
      + cgi.code { coder.encode(kv.to_s) }
    }
  }
}

