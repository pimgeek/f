// 引用相关模块
var http = require('http');
var qs = require('querystring');
var xml2js = require('xml2js');
var yamljs = require('yamljs');

// 定义全局变量
var serverPort = 80;
var htmlOpening = '<html><head><meta charset="utf8" /></head><body>'; // html 开始部分代码
var htmlClosing = '</body></html>'; // html 结束部分代码

// 处理找不到该页的情况
function renderNotFoundWebPage(res) {
  res.writeHead(404, {
    'Content-Type': 'text/html'
  });
  res.write(htmlOpening);
  res.write('<h1>没有找到这个页面!</h1>');
  res.write(htmlClosing);
  res.end();
}

// 展示 Yaml 转 Opml 的输入表单
function renderYamlToOpmlForm(res) {
  res.writeHead(200, {
    'Content-Type': 'text/html'
  });
  res.write(htmlOpening);
  res.write(
    '<h1>请把 YAML 格式的笔记粘贴到此处</h1>' +
    '<form action="/yaml2opml" method="POST">' +
    '<textarea id="yamlText" name="yamlText" /></textarea>' +
    '<br />' +
    '<input id="exportOpml" type="submit" value="导出为 opml 格式" />' +
    '</form>'
  );
  res.write(htmlClosing);
  res.end();
}

// 处理来自客户端的各种 POST 请求，
// 从中抽取出表单中的参数并做后续处理
function procPostReq(req, res, endProcFunc) {
  // 如果请求长度超过限制，将返回错误代码 413
  // 如何请求长度不超限制，则返回正常代码 200，
  // 并在 formJsonObj.formData 中存储表单的参数
  var reqBody = '';
  var formJson = {};

  req.on('data', function(data) {
    reqBody += data;
    if (reqBody.length > 1e4) {
      formJson.responseStatus = 413;
      formJson.errorMessage = '请求内容长度超出限制！';
      return formJson;
    } else {
      ;
    }
  });

  req.on('end', function(data) {
    formJson.responseStatus = 200; // 返回处理成功的状态码
    formJson.formData = qs.parse(reqBody); // 返回表单中的参数
    endProcFunc(res, formJson);
  });

  return formJson; // 返回处理失败的状态码
}

function convertJsonToOpml(jsonObj){
  var builder = new xml2js.Builder();
  var xml = builder.buildObject(jsonObj);
  console.log(xml);
  return xml;
}

function htmlEscape(str) {
    return String(str)
            .replace(/&/g, '&amp;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;');
}

// I needed the opposite function today, so adding here too:
function htmlUnescape(value){
    return String(value)
        .replace(/&quot;/g, '"')
        .replace(/&#39;/g, "'")
        .replace(/&lt;/g, '<')
        .replace(/&gt;/g, '>')
        .replace(/&amp;/g, '&');
}

// 把 opml 格式的数据渲染为 html 网页
function renderOpmlWebPage(res, formJson){  // 定义搜索结果反馈页面
  var yamlText = formJson.formData.yamlText;
  var jsonObj = yamljs.parse(yamlText);
  var opml = convertJsonToOpml(jsonObj);
  res.writeHead(200, {
    'Content-Type': 'text/html'
  });
  res.write(htmlOpening);
  res.write('<h1>OPML 输出</h1>');
  res.write('<pre>' + htmlEscape(opml) + '</pre>');
  res.write(htmlClosing);
  res.end();
}

// 把提交的数据导出为 opml 格式
function exportOpml(req, res){
  procPostReq(req, res, renderOpmlWebPage);
}

// 创建 node webapp 的服务端
var webapp = http.createServer(
  function(req, res) {
    if (req.method === 'GET') {
      if (req.url === '/opml2json') {
        renderOpmlToJsonForm(res);
      } else if (req.url === '/yaml2opml') {
        renderYamlToOpmlForm(res);
      } else {
        renderNotFoundWebPage(res);
      }
    } else if (req.method === 'POST') {
      if (req.url === '/opml2json') {
        exportJson(opmlObj);
      } else if (req.url === '/yaml2opml') {
        exportOpml(req, res);
      } else {
        renderNotFoundWebPage(req, res);
      }
    } else {
      res.end();
    }
  }).listen(serverPort,
  function() {
    console.log('NodeJS App 正通过 ' + serverPort + ' 端口提供服务');
  });
