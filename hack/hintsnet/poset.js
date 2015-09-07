#!/usr/bin/node

// poset = partial order set

var infer = require('infer-partial-order')

console.log(infer([['加减法','乘除法'], ['加减法', '数轴', '负数'], ['负数','现金流','贴现']]))
