// 引用相关模块
var fs = require('fs');
var http = require('http');
var qs = require('querystring');
var restler = require('restler');

// 定义全局变量
var configFile = 'config.json';
var configJson = JSON.parse(fs.readFileSync(configFile));
var dbaasHost = configJson.dbaasHost;
var dbaasDbName = configJson.dbaasDbName;
var dbaasUser = configJson.dbaasUser;
var dbaasPass = configJson.dbaasPass;
var dbaasFindApiUrl = dbaasHost + '/' + dbaasDbName + '/_find';

// 定义变量
var serverPort = 3000; // web 服务的监听端口
var htmlOpening = '<html><head><meta charset="utf8" /></head><body>'; // html 开始部分代码
var htmlClosing = '</body></html>'; // html 结束部分代码

// 处理找不到该页的情况
function renderNotFound(req, res) {
  res.writeHead(404, {
    'Content-Type': 'text/html'
  });
  res.write(htmlOpening);
  res.write('<h1>没有找到这个页面!</h1>');
  res.write(htmlClosing);
  res.end();
}

// 展示一条笔记
function renderNoteForm(req, res) {
  res.writeHead(200, {
    'Content-Type': 'text/html'
  });
  res.write(htmlOpening);
  res.write(
    '<h1>查看已有笔记</h1>' +
    '<form action="/note" method="POST">' +
    '<input id="noteId" name="noteId" type="text" value="笔记标识" />' +
    '<br />' +
    '<input id="fetchNote" type="submit" value="获取笔记" />' +
    '</form>'
  );
  res.write(htmlClosing);
  res.end();
}

// 生成全文搜索表单
function renderSearchForm(req, res) {
  res.writeHead(200, {
    'Content-Type': 'text/html'
  });
  res.write(htmlOpening);
  res.write(
    '<h1>搜索笔记库</h1>' +
    '<form action="/search" method="POST">' +
    '<input id="keywords" name="keywords" type="text" value="搜索关键词" />' +
    '<br />' +
    '<input id="search" type="submit" value="全文搜索" />' +
    '</form>'
  );
  res.write(htmlClosing);
  res.end();
}

// 生成笔记创建表单
function renderNewForm(req, res) {
  res.writeHead(200, {
    'Content-Type': 'text/html'
  });
  res.write(htmlOpening);
  res.write(
    '<h1>创建新笔记</h1>' +
    '<form action="/new" method="POST">' +
    '<textarea id="note" name="note-content" value="笔记内容" />' +
    '<br />' +
    '<input id="newNote" type="submit" value="创建新笔记" />' +
    '</form>'
  );
  res.write(htmlClosing);
  res.end();
}

// 为提交笔记获取请求而创建 JSON 对象
function makeNoteJson(res, formJson) {
  var jsonReq = { // 需要提交的搜索请求 JSON
    "selector": {
      "_id": formJson.formData.noteId
    },
    "fields": [
      "note"
    ]
  };
  return jsonReq;
}

// 为提交全文搜索请求而创建 JSON 对象
function makeSearchJson(res, formJson) {
  var jsonReq = { // 需要提交的搜索请求 JSON
    "selector": {
      "$text": formJson.formData.keywords
    },
    "fields": [
      "note"
    ]
  };
  return jsonReq;
}

// 处理来自客户端的各种 POST 请求，从中抽取出表单中的参数并做后续处理
function procPostReq(req, res, endProcFunc) {
  // 如果请求长度超过限制，将返回错误代码 413
  // 如何请求长度不超限制，则返回正常代码 200，
  // 并在 json_obj.form_data 中存储表单的参数
  var reqBody = '';
  var formJson = {
    responseStatus: '',
    errorMessage: '',
    formData: {}
  };

  req.on('data', function(data) {
    reqBody += data;
    if (reqBody.length > 1e7) {
      formJson.response_status = 413;
      formJson.error_message = '请求内容长度超出限制！';
      return formJson; // 返回处理失败的状态码
    }
  });
  req.on('end', function() {
    var jsonReq = '';
    formJson.response_status = 200; // 返回处理成功的状态码
    formJson.formData = qs.parse(reqBody); // 返回表单中的参数
    endProcFunc(res, formJson);
  });
}

// 在一级请求的处理过程中提交各种针对 DBaaS 服务器的二级请求
function sendSecondLevelReq(res, formJson, jsonProcFunc, dbaasProcApiUrl) {
  var jsonReq = {};
  var jsonReqStr = '';

  // 从表单参数的 json 数据对象中提取信息，
  // 并且生成后续的 Web 请求 json 数据对象
  jsonReq = jsonProcFunc(res, formJson);

  // 为提交 restler 请求，把 JSON 对象转为字符串
  jsonReqStr = JSON.stringify(jsonReq, null, 2);

  // 定义搜索结果反馈页面
  res.writeHead(200, {
    'Content-Type': 'text/html'
  });
  res.write(htmlOpening);
  restler.post(dbaasProcApiUrl, {
    username: dbaasUser,
    password: dbaasPass,
    headers: {
      'Content-Type': 'application/json'
    },
    data: jsonReqStr
  }).on('complete', function(jsonResStr, secondLevelRes) {
    res.write('<h1>返回值' + secondLevelRes.statusCode + '</h1>');
    res.write('<pre>' + JSON.stringify(JSON.parse(jsonResStr).docs) + '</pre>');
    res.write(htmlClosing);
    res.end();
  });
}

// 提交笔记获取请求
function sendNoteReq(res, formJson) {
  sendSecondLevelReq(res, formJson, makeNoteJson, dbaasFindApiUrl);
}

// 提交全文搜索请求
function sendSearchReq(res, formJson) {
  sendSecondLevelReq(res, formJson, makeSearchJson, dbaasFindApiUrl);
}

// 创建 node webapp 的服务端
var webapp = http.createServer(
  function(req, res) {
    if (req.method === 'GET') {
      if (req.url === '/note') {
        renderNoteForm(req, res);
      } else if (req.url === '/search') {
        renderSearchForm(req, res);
      } else {
        renderNotFound(req, res);
      }
    } else if (req.method === 'POST') {
      if (req.url === '/note') {
        procPostReq(req, res, sendNoteReq);
      } else if (req.url === '/search') {
        procPostReq(req, res, sendSearchReq);
      } else {
        renderNotFound(req, res);
      }
    } else {
      return res.end();
    }
  }).listen(serverPort,
  function() {
    console.log('NodeJS App 正通过 http://192.168.56.101:3000 提供服务');
  });