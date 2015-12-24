// 引用相关模块

// 定义全局变量
var serverPort = 80;
var htmlOpening = '<html><head><meta charset="utf8" /></head><body>'; // html 开始部分代码
var htmlClosing = '</body></html>'; // html 结束部分代码

// 处理找不到该页的情况
function renderNotFound(res) {
  res.writeHead(404, {
    'Content-Type': 'text/html'
  });
  res.write(htmlOpening);
  res.write('<h1>没有找到这个页面!</h1>');
  res.write(htmlClosing);
  res.end();
}

// 展示 Yaml 转 Opml 的输入表单
function renderWorkflowyYamlToOpmlForm(res) {
  res.writeHead(200, {
    'Content-Type': 'text/html'
  });
  res.write(
    htmlOpening +
    '<h1>请把 YAML 格式的 Workflowy 笔记粘贴到此处</h1>' +
    '<form action="/yaml2opml-wf" method="POST">' +
    '<textarea id="yamlText" name="yamlText" /></textarea>' +
    '<br />' +
    '<input id="exportOpml" type="submit" value="导出为 opml 格式（Workflowy）" />' +
    '</form>' +
    htmlClosing
  );
  res.end();
}

// 展示 Yaml 转 Opml 的输入表单
function renderTranslationYamlToOpmlForm(res) {
  res.writeHead(200, {
    'Content-Type': 'text/html'
  });
  res.write(
    htmlOpening +
    '<h1>请把 YAML 格式的 Translation 笔记粘贴到此处</h1>' +
    '<form action="/yaml2opml-trans" method="POST">' +
    '<textarea id="yamlText" name="yamlText" /></textarea>' +
    '<br />' +
    '<input id="exportOpml" type="submit" value="导出为 opml 格式（Translation）" />' +
    '</form>' +
    htmlClosing
  );
  res.end();
}

// 展示 Json 转 Opml 的输入表单
function renderJsonToOpmlForm(res) {
  res.writeHead(200, {
    'Content-Type': 'text/html'
  });
  res.write(
    htmlOpening +
    '<h1>请把 JSON 格式的笔记粘贴到此处</h1>' +
    '<form action="/json2opml" method="POST">' +
    '<textarea id="jsonText" name="jsonText" /></textarea>' +
    '<br />' +
    '<input id="exportOpml" type="submit" value="导出为 opml 格式" />' +
    '</form>' +
    htmlClosing
  );
  res.end();
}

// 处理来自客户端的各种 POST 请求，
// 从中抽取出表单中的参数并做后续处理
function procPostReq(req, res, endProcFunc) {
  // 如果请求长度超过限制，将返回错误代码 413
  // 如何请求长度不超限制，则返回正常代码 200，
  // 并在 formJsonObj.formData 中存储表单的参数
  var qs = require('querystring');
  var rawReqData = '';
  var formDataObj = {};

  req.on('data', function(data) {
    rawReqData += data;
    if (rawReqData.length > 1e4) {
      formDataObj.responseStatus = 413;
      formDataObj.errorMessage = '请求内容长度超出限制！';
      return formJson;
    } else {;
    }
  });

  req.on('end', function(data) {
    formDataObj.responseStatus = 200; // 返回处理成功的状态码
    formDataObj.formData = qs.parse(rawReqData); // 返回表单中的参数
    endProcFunc(res, formDataObj);
  });

  return formDataObj; // 返回处理失败的状态码
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
function htmlUnescape(value) {
  return String(value)
    .replace(/&quot;/g, '"')
    .replace(/&#39;/g, "'")
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&amp;/g, '&');
}

// 专门针对 workflowy Outline 格式的 json parser
function workflowyOutlineJsonParser(jsonObj) {
  var outlinesJsonObj = {};
  var outlineMetaObj = {};
  for (key in jsonObj) {
    var value = jsonObj[key];
    if ('string' === typeof(value)) {
      outlineMetaObj[key] = value;
      outlinesJsonObj['$'] = outlineMetaObj;
    } else if (true === Array.isArray(value)) {
      outlinesJsonObj['outline'] = value.map(workflowyOutlineJsonParser);
    } else {;
    }
  }
  return outlinesJsonObj;
}

// 专门针对 translation Outline 格式的 json parser
function translationOutlineJsonParser(jsonObj) {
  var outlinesJsonObj = { 'outline': [] };
  for (key in jsonObj) {
    var outlineMetaObj = {};
    var value = jsonObj[key];
    if ('string' === typeof(value)) {
      outlineMetaObj['text'] = key;
      outlineMetaObj['_note'] = value;
      outlinesJsonObj['outline'].push({
        '$': outlineMetaObj
      });
    } else if ('object' === typeof(value)) {
      outlineMetaObj = {
        '$': { 'text': key },
        'outline': (translationOutlineJsonParser(value))['outline']
      };
      outlinesJsonObj['outline'].push(outlineMetaObj);
    } else {;
    }
  }
  return outlinesJsonObj;
}

function convertJsonToOpml(jsonText, outlineParser) {
  var xml2js = require('xml2js');
  var builder = new xml2js.Builder();
  var outlinesJsonObj = outlineParser(JSON.parse(jsonText));
  var workflowyJsonObj = {
    'opml': {
      $: {
        'version': '2.0'
      },
      'body': outlinesJsonObj
    }
  };
  var xmlText = builder.buildObject(workflowyJsonObj);
  return xmlText;
}

function convertYamlToJson(yamlText) {
  var yamljs = require('yamljs');
  return yamljs.parse(yamlText);
}

function simpleWebReport(titleText, reportText) {
  return htmlOpening +
    '<h1>' + titleText + '</h1>' +
    '<pre>' + reportText + '</pre>' +
    htmlClosing;
}

// 把 opml 格式的数据渲染为 html 网页
function renderExportOpmlFromWorkflowyYaml(res, formDataObj) { // 定义搜索结果反馈页面
  var yamlText = formDataObj.formData.yamlText;
  var jsonText = JSON.stringify(convertYamlToJson(yamlText));
  var opmlText = convertJsonToOpml(jsonText, workflowyOutlineJsonParser);
  res.writeHead(200, {
    'Content-Type': 'text/html'
  });
  res.write(simpleWebReport('导出结果', htmlEscape(opmlText)));
  res.end();
}

// 把 TranslationYaml 格式的数据渲染为 html 网页
function renderExportOpmlFromTranslationYaml(res, formDataObj) { // 定义搜索结果反馈页面
  var yamlText = formDataObj.formData.yamlText;
  var jsonText = JSON.stringify(convertYamlToJson(yamlText));
  var opmlText = convertJsonToOpml(jsonText, translationOutlineJsonParser);
  res.writeHead(200, {
    'Content-Type': 'text/html'
  });
  res.write(simpleWebReport('导出结果', htmlEscape(opmlText)));
  res.end();
}

// 把 opml 格式的数据渲染为 html 网页
function renderExportOpmlFromJson(res, formDataObj) { // 定义搜索结果反馈页面
  var jsonText = formDataObj.formData.jsonText;
  var opmlText = convertJsonToOpml(jsonText);
  res.writeHead(200, {
    'Content-Type': 'text/html'
  });
  res.write(simpleWebReport('导出结果', htmlEscape(opmlText)));
  res.end();
}

// 把提交的数据导出为 opml 格式
function exportOpmlFromJson(req, res) {
  procPostReq(req, res, renderExportOpmlFromJson);
}

// 把提交的 workflowy Yaml 数据导出为 opml 格式
function exportWorkflowyOpmlFromYaml(req, res) {
  procPostReq(req, res, renderExportOpmlFromWorkflowyYaml);
}

// 把提交的 translation Yaml 数据导出为 opml 格式
function exportTranslationOpmlFromYaml(req, res) {
  procPostReq(req, res, renderExportOpmlFromTranslationYaml);
}

// 把提交的数据导出为 opml 格式
function exportOpmlFromTranslationYaml(req, res) {
  procPostReq(req, res, renderExportOpmlFromTranslationYaml);
}

// 创建 node webapp 的服务端
var http = require('http');
var webapp = http.createServer(
  function(req, res) {
    if (req.method === 'GET') {
      if (req.url === '/opml2json') {
        renderOpmlToJsonForm(res);
      } else if (req.url === '/json2opml') {
        renderJsonToOpmlForm(res);
      } else if (req.url === '/yaml2opml-wf') {
        renderWorkflowyYamlToOpmlForm(res);
      } else if (req.url === '/yaml2opml-trans') {
        renderTranslationYamlToOpmlForm(res);
      } else {
        renderNotFound(res);
      }
    } else if (req.method === 'POST') {
      if (req.url === '/opml2json') {
        exportJsonFromOpml(opmlObj);
      } else if (req.url === '/json2opml') {
        exportOpmlFromJson(req, res);
      } else if (req.url === '/yaml2opml-wf') {
        exportWorkflowyOpmlFromYaml(req, res);
      } else if (req.url === '/yaml2opml-trans') {
        exportTranslationOpmlFromYaml(req, res);
      } else {
        renderNotFound(req, res);
      }
    } else {
      res.end();
    }
  }).listen(serverPort,
  function() {
    console.log('NodeJS App 正通过 ' + serverPort + ' 端口提供服务');
  });
