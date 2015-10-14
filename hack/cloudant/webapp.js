// 引用相关模块
var http = require('http');
var qs = require('querystring');
var restler = require('restler');

// 定义全局变量
var dbaas_host = 'https://pimgeek.cloudant.com';
var dbaas_db = 'pim-flow';
var dbaas_api_url_find = dbaas_host + '/' + dbaas_db + '/_find';
var dbaas_user = 'edstaremallnevendshoothe';
var dbaas_pass = '0ff0d1715c9c4ecde460e44a6a6112b8402c9a17';

// 定义变量
var server_port = 3000; // web 服务的监听端口
var html_opening = '<html><head><meta charset="utf8" /></head><body>'; // html 开始部分代码
var html_closing = '</body></html>'; // html 结束部分代码

// 处理找不到该页的情况
function showNotFound(req, res) {
  res.writeHead(404, {
    'Content-Type': 'text/html'
  });
  res.write(html_opening);
  res.write('<h1>没有找到这个页面!</h1>');
  res.write(html_closing);
  res.end();
}

// 生成新建笔记表单
function showNewForm(req, res) {
  res.writeHead(200, {
    'Content-Type': 'text/html'
  });
  res.write(html_opening);
  res.write(
    '<h1>创建新笔记</h1>' +
    '<form action="/new" method="POST">' +
    '<input id="note-title" name="note-title" type="text" value="笔记标题" />' +
    '<br />' +
    '<textarea id="note-content" name="note-content" value="笔记内容" />' +
    '<br />' +
    '<input id="new-note" type="submit" value="创建新笔记" />' +
    '</form>'
  );
  res.write(html_closing);
  res.end();
}

// 生成全文搜索表单
function showSearchForm(req, res) {
  res.writeHead(200, {
    'Content-Type': 'text/html'
  });
  res.write(html_opening);
  res.write(
    '<h1>搜索笔记库</h1>' +
    '<form action="/search" method="POST">' +
    '<input id="keywords" name="keywords" type="text" value="搜索关键词" />' +
    '<br />' +
    '<input id="search" type="submit" value="全文搜索" />' +
    '</form>'
  );
  res.write(html_closing);
  res.end();
}

// 处理来自客户端的各种 POST 请求，从中抽取出表单中的参数并做后续处理
function procPostRequest(req, res, endProcFunc) {
  // 如果请求长度超过限制，将返回错误代码 413
  // 如何请求长度不超限制，则返回正常代码 200，
  // 并在 json_obj.form_data 中存储表单的参数
  var req_body = '';
  var form_json_obj = {
    response_status: '',
    error_message: '',
    form_data: {}
  };

  req.on('data', function(data) {
    req_body += data;
    if (req_body.length > 1e7) {
      form_json_obj.response_status = 413;
      form_json_obj.error_message = '请求内容长度超出限制！';
      return form_json_obj; // 返回处理失败的状态码
    }
  });
  req.on('end', function() {
    var json_req_obj = '';
    form_json_obj.response_status = 200; // 返回处理成功的状态码
    form_json_obj.form_data = qs.parse(req_body); // 返回表单中的参数
    endProcFunc(res, form_json_obj);
  });
}

// 处理新建笔记的请求
function procNewForm(req, res) {
  var req_body = '';
}

// 为提交全文搜索请求而创建 JSON 对象
function procSearchJsonObj(res, form_json_obj) {
  var json_req_obj = { // 需要提交的搜索请求 JSON
    "selector": {
      "$text": form_json_obj.form_data.keywords
    },
    "fields": [
      "note"
    ]
  };
  return json_req_obj;
}

// 提交全文搜索请求
function sendSearchRequest(res, form_json_obj) {
  var json_req_obj = {};
  var json_req_string = '';

  // 从表单参数的 json 数据对象中提取信息，
  // 并且生成后续的 Web 请求 json 数据对象
  json_req_obj = procSearchJsonObj(res, form_json_obj);

  // 为提交 restler 请求，把 JSON 对象转为字符串
  json_req_string = JSON.stringify(json_req_obj, null, 2);

  // 定义搜索结果反馈页面
  res.writeHead(200, {
    'Content-Type': 'text/html'
  });
  res.write(html_opening);
  restler.post(dbaas_api_url_find, {
    username: dbaas_user,
    password: dbaas_pass,
    headers: {
      'Content-Type': 'application/json'
    },
    data: json_req_string
  }).on('complete', function(data, response) {
    res.write('<h1>' + response.statusCode + '</h1>');
    res.write('<pre>' + JSON.stringify(JSON.parse(data).docs) + '</pre>');
    res.write(html_closing);
    res.end();
  });
}

// 创建 node webapp 的服务端
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
        procPostRequest(req, res, sendSearchRequest);
      } else {
        showNotFound(req, res);
      }
    } else {
      return res.end();
    }
  }).listen(server_port,
  function() {
    console.log('NodeJS App 正通过 http://192.168.56.101:3000 提供服务');
  });