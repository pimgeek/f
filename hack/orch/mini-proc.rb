# -*- coding: utf-8 -*-
## 引入 orchestrate 对应的 gem
require 'orchestrate'

# 使用 Orchestrate::Client 方式调用
host = 'https://api.ctl-sg1-a.orchestrate.io'
api_key = '19efed2d-c8fa-465a-a7d5-eb424e15b356'
#client = Orchestrate::Client.new(api_key, host)
# 测试 api_key 是否合法有效
#p client.ping

# 使用 Orchestrate::Application 方式调用
app = Orchestrate::Application.new(api_key, host)

# 尝试访问（不存在就创建）一个名为 orig-en 的 collection
orig_en = app[:orig_en]
#key_dt = Time.now.strftime("dt%Y%m%d%H%M%S").to_sym
#p orig_en.set(key_dt, {
#  "words" => "Mindfulness in Plain English."
#})

# 尝试搜索一些包含 "Mindfulness" 的句子，并返回其 key
resp = orig_en.search('Mindfulness').find
resp.each { |s,kv| p kv.key }