#!/usr/bin/node

// poset = partial order set
// infer-partial-order 是 nodejs 的库，可以用 npm install infer-partial-order 安装
// 利用 browserify src.js -o dest.js 可以把 nodejs 源码转换为纯前端代码
// 简言之，可以脱离服务端，直接在浏览器上支持 require 函数

var infer = require('infer-partial-order')

var result_obj = infer([['加减法','乘除法'], ['加减法', '数轴', '负数'], ['负数','现金流','贴现']])

// 如果想自己控制输出格式的话……

var output = ''

for (var property in result_obj) {
  output += property + ': ' + result_obj[property] + '<br/>'
}

document.write(JSON.stringify(result_obj,null,2))
