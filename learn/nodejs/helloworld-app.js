// 用 node app.js 运行即可

// 引用 http 模块
var http = require('http');

// 创建一个简单的服务器
var app = http.createServer(
  function(request, response) {
    response.writeHead(200, {'Content-Type': 'text/plain'});
    response.end('Hello, World!\n');
  });

// 设置监听端口为 3000
app.listen(3000);

// 在浏览器控制台输出信息
console.log('NodeJS App Running at http://192.168.56.101:3000');

