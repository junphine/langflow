
const { createProxyMiddleware } = require('http-proxy-middleware')

module.exports = function (app)  {
  app.use(
    // 代理 1
    '/_api/v1', 
    createProxyMiddleware({             // 匹配到 '/api' 前缀的请求，就会触发该代理配置
      target: 'http://127.0.0.1:7860/api/v1',  // 请求转发地址
      //secure: false,
      changeOrigin: true,                             // 是否跨域
        
    }), 
    
  )
  app.use( // 代理 2   
    '/api/v2',
    createProxyMiddleware({
      target: 'http://127.0.0.1:7860/api/v2',
      //secure: false,
      changeOrigin: true,
      router: {        
       'localhost:3000' : 'http://localhost:7860'
      }
    }),   
  )
}
