(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){


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

},{"infer-partial-order":2}],2:[function(require,module,exports){


function union (a, b) {
  if(b == null) return a
  var c = []
  b.forEach(function (v) {
    if(~a.indexOf(v)) c.push(v)
  })
  return c.sort()
}

function remove(ary, v) {
  var i = ary.indexOf(v)
  if(~i) ary.splice(i, 1)
  return ary
}

function clean (order) {
  var newOrder = {}
  for(var key in order) {
    var after = order[key]

    //remove all the items that the are indirectly before key.
    var direct = after.slice()
    after.forEach(function (k) {
      order[k].forEach(function (v) {
        remove(direct, v)
      })
    })
    newOrder[key] = direct
  }
  return newOrder
}

module.exports = function (examples, doClean) {

  var order = {}
  examples.forEach(function (seq, i) {
    var seen = []
    seq.forEach(function (value) {
      order[value] = union(seen.slice(), order[value])
      seen.push(value)
    })
    if(order) return
  })

  if(doClean)
    return clean(order)

  return order
}

module.exports.canonical = clean

},{}]},{},[1]);
