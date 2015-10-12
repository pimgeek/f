# 利用 nodejs 的 restler 模块操纵 couchdb / cloudant

- restler 网址(含帮助文档) - https://github.com/danwrong/restler

- cloudant 网址
  - https://pimgeek.cloudant.com/dashboard.html
  - https://docs.cloudant.com/"

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
    if (response.statusCode == 201) {
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
    if (response.statusCode == 201) {
      // you can get at the raw response like this...
      console.log('Doc Updated!');
    } else {
      console.log(response.statusCode);
    }
  });
```
