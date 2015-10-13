// 引用相关模块
var http = require('http');
var qs = require('querystring');
var restler = require('restler');

// 定义变量
var server_port = 3000; // web 服务的监听端口
var html_opening = '<html><head><meta charset="utf8" /></head><body>'; // html 开始部分代码
var html_closing = '</body></html>'; // html 结束部分代码

function showNotFound(req, res) {
  res.writeHead(404, {
    'Content-Type': 'text/html'
  });
  res.write(html_opening);
  res.write('<h1>没有找到这个页面!</h1>');
  res.write(html_closing);
  res.end();
}

function showSearchForm(req, res) {
  res.writeHead(200, {
    'Content-Type': 'text/html'
  });
  res.write(html_opening);
  res.write('<h1>搜索笔记库</h1>' +
    '<form action="/search" method="POST">' +
    '<input id="keywords" name="keywords" type="text" value="搜索关键词" />' +
    '<br />' +
    '<input id="search" type="submit" value="全文搜索" />' +
    '</form>'
  );
  res.write(html_closing);
  res.end();
}

function procSearchForm(req, res) {
  var req_body = '';
  req.on('data', function(data) {
    req_body += data;
    if (req_body.length > 1e7) {
      res.writeHead(413, '请求内容超出限制！', {
        'Content-Type': 'text/html'
      });
      res.write(html_opening);
      res.write('<h1>413: 请求内容超出限制！</h1>');
      res.write(html_closing);
      res.end();
    }
  });
  req.on('end', function() {
    // 定义相关变量
    var form_data = qs.parse(req_body); // 表单中的数值
    var json_request = JSON.stringify({ // 需要提交的搜索请求 JSON
      "selector": {
        "$text": form_data.keywords
      },
      "fields": [
        "note"
      ]
    }, null, 2);
    // 定义搜索结果反馈页面
    res.writeHead(200, {
      'Content-Type': 'text/html'
    });
    res.write(html_opening);
    restler.post('https://pimgeek.cloudant.com/pim-flow/_find', {
      username: 'edstaremallnevendshoothe',
      password: '0ff0d1715c9c4ecde460e44a6a6112b8402c9a17',
      headers: {
        'Content-Type': 'application/json'
      },
      data: json_request
    }).on('complete', function(data, response) {
      res.write('<h1>' + response.statusCode + '</h1>');
      res.write('<pre>' + JSON.stringify(JSON.parse(data).docs) + '</pre>');
      res.write(html_closing);
      res.end();
    });
  });
}

var webapp = http.createServer(
  function(req, res) {
    if (req.method === 'GET') {
      if (req.url === '/favicon.ico') {
        showNotFound(req, res);
      } else {
        showSearchForm(req, res);
      }
    } else if (req.method === 'POST') {
      if (req.url === '/search') {
        procSearchForm(req, res);
      } else {
        showNotFound(req, res);
      }
    } else {
      return res.end();
    }
  });

webapp.listen(server_port,
  function() {
    console.log('NodeJS App Running at http://192.168.56.101:3000');
  });
