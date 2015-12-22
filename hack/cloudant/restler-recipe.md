# 利用 nodejs 的 restler 模块操纵 couchdb / cloudant

- restler 网址(含帮助文档) - https://github.com/danwrong/restler

- cloudant 官网网址
  - https://pimgeek.cloudant.com/dashboard.html
  - https://docs.cloudant.com/

- 利用 restler 获取 json 页面，并操纵之

```nodejs
  var restler = require('restler');
  restler.get('http://api.douban.com/book/subject/1220562?alt=json').
    on('complete', function(data) {
    console.log(data.title.$t); // auto convert to object
  });
```

- 利用 restler 获取 xml 页面，直接转换为 json 并操纵之

```nodejs
  var restler = require('restler');
  restler.get('http://api.douban.com/book/subject/1220563',
    { 'parser': restler.parsers.xml}).
    on('complete', function(data,response) {
    console.log(data.entry.title);
  });
  // ========
  var restler = require('restler');
  restler.get('http://192.168.56.101:4001/sample/workflowy-2015-10-12.txt', { parser: restler.parsers.xml }).on('complete',
  function(data) {
    console.log(data.opml.body[0].outline[0]);
  });
```

- 利用 restler 更新 couchdb 中已经存在的 document

```nodejs
  var restler = require('restler');
  restler.postJson('https://edstaremallnevendshoothe:0ff0d1715c9c4ecde460e44a6a6112b8402c9a17@pimgeek.cloudant.com/pim-flow', {
    '_id': '647f5d53217c6cf8f73c8b9dc3c21dd6',
    '_rev': '1-03756a10670e3946f3778c43e50bb66e',
    'pi': 3.14159265358979
  }).on('complete', function(data, response) {
    if (response.statusCode === 201) {
      // you can get at the raw response like this...
      console.log('Doc Updated!');
    } else {
      console.log(response.statusCode);
    }
  });
```

- 利用 restler 向 couchdb 中批量导入 json 数据

```nodejs
  var restler = require('restler');
  restler.postJson('https://edstaremallnevendshoothe:0ff0d1715c9c4ecde460e44a6a6112b8402c9a17@pimgeek.cloudant.com/pim-flow/_bulk_docs', {
    'docs': [
    { note: 'google 搜索技法' },
    { note: '社会性拒绝理论' },
    { note: '大脑的自我重塑' },
    { note: 'gosol / hintsnet 知识整理法' }
    ]
  }).on('complete', function(data, response) {
    if (response.statusCode === 201) {
      // you can get at the raw response like this...
      console.log('文档更新完毕！');
    } else {
      console.log(response.statusCode);
    }
  });
```

- 利用 restler 为 couchdb 创建 fulltext search index
  - 创建索引需要 api 的 url 用户名拥有 admin 权限

```nodejs
  var restler = require('restler');
  var url = 'https://edstaremallnevendshoothe:0ff0d1715c9c4ecde460e44a6a6112b8402c9a17@pimgeek.cloudant.com/pim-flow/_index';
  var fulltext_index_json = {
    'type': 'text',
    'name': 'fulltext-index',
    'index': {
      'fields': [
        { 'name': 'note', 'type': 'string' }
      ]
    }
  };
  restler.postJson(url, fulltext_index_json).
    on('complete', function(data, response) {
      if (response.statusCode === 200) {
        console.log('全文索引成功建立！');
        console.log(data);
      } else {
        console.log('出现问题... ');
        console.log(response.statusCode);
      }
    });
```

- 利用 restler 查询 couchdb 中的 json 数据

```nodejs
  var restler = require('restler');
  var url = 'https://edstaremallnevendshoothe:0ff0d1715c9c4ecde460e44a6a6112b8402c9a17@pimgeek.cloudant.com/pim-flow/_find';
  var fulltext_search_json = {
    "selector": {
      "$text": "法"
    },
    "fields": [
      "note"
    ]
  };
  restler.postJson(url,fulltext_search_json).
    on('complete', function(data, response) {
      if (response.statusCode === 200) {
        console.log('搜索请求执行完毕！');
        console.log(data);
      } else {
        console.log(response.statusCode);
      }
    });
```

- 利用 restler 的 post() 函数完成 json 请求
  - post() 函数的好处是，可以把一些请求过程中使用的参数如 username, password 等单独列举出来。

```nodejs
  var restler = require('restler');
  var jsonReq = JSON.stringify({
      "selector": {
        "$text": "法"
      },
      "fields": [
        "note"
      ]
    }, null, 2);
  restler.post('https://pimgeek.cloudant.com/pim-flow/_find', {
    username: 'edstaremallnevendshoothe',
    password: '0ff0d1715c9c4ecde460e44a6a6112b8402c9a17',
    headers: { 'Content-Type': 'application/json' },
    data: jsonReq
  }).on('complete', function(data, response) {
    console.log(data);
    console.log(response.statusCode);
  });
```

- 利用 restler 的 _all_docs api 获取所有文档列表

```nodejs
  var restler = require('restler');
  restler.post('https://pimgeek.cloudant.com/pim-flow/_all_docs', {
    username: 'edstaremallnevendshoothe',
    password: '0ff0d1715c9c4ecde460e44a6a6112b8402c9a17',
    query: { 
      // 可参考 https://docs.cloudant.com/database.html#get-documents 了解更多参数
      include_docs: true,
      limit: 10
    },
    data: '{}'
  }).on('complete', function(data, res) {
    console.log(data);
    console.log(res.statusCode);
  });
```

- 利用 restler 的 del 函数完成笔记删除请求

```nodejs
  var restler = require('restler');
  var jsonReq = JSON.stringify({
      _id: '647f5d53217c6cf8f73c8b9dc365d51f'
    }, null, 2);
  restler.del('https://pimgeek.cloudant.com/pim-flow', {
    username: 'edstaremallnevendshoothe',
    password: '0ff0d1715c9c4ecde460e44a6a6112b8402c9a17',
    headers: { 'Content-Type': 'application/json' },
    data: jsonReq
  }).on('complete', function(data, response) {
    console.log(data);
    console.log(response.statusCode);
  });
```