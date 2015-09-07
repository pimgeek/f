#!/usr/bin/node

// poset = partial order set
// infer-partial-order 是 nodejs 的库，可以用 npm install infer-partial-order 安装

var infer = require('infer-partial-order')

console.log(infer([['加减法','乘除法'], ['加减法', '数轴', '负数'], ['负数','现金流','贴现']]))
