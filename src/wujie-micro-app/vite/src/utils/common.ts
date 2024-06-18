import AMapLoader from '@amap/amap-jsapi-loader';
 const  getKey = ()=> {
    let arr = [
        {
          key:"2e1d11eeccafc478411e3029f84b3530",
          jscode:"28aeaf6b9b53d7715e5ad8ea8ca8be81",
        },
      ];
      if (sessionStorage.getItem('key')) {
        let keyObj = JSON.parse(window.sessionStorage.getItem('key')||'')
        if(keyObj.jscode){
          (window as any)._AMapSecurityConfig = {
              securityJsCode: keyObj.jscode,
          }
        }
        return keyObj
      }else{
        let keys = arr[Math.floor(Math.random() * arr.length)];
        if(keys.jscode){
            (window as any)._AMapSecurityConfig = {
              securityJsCode: keys.jscode,
          }
        }
        sessionStorage.setItem('key', JSON.stringify(keys));
        return keys
      }
      // 创建script标签，引入外部文件
    //   console.log(keys);
  }
export  function loadJs(src) {
    let AMapKey = getKey()
    console.log(6526666 )
   return  new Promise((resolve, reject)=>{
        AMapLoader.load({
            key: AMapKey.key,  //设置您的key
            version:"1.4.15",
            plugins:['AMap.MouseTool','AMap.RangingTool','AMap.Geocoder','AMap.DistrictSearch','AMap.ToolBar','AMap.Driving','AMap.Autocomplete','AMap.PlaceSearch','AMap.PolyEditor'],
            AMapUI:{
                version:"1.1",
                plugins:[],

            },
            Loca:{
                version:"1.4.15"
            },
        }).then((AMap)=>{
            console.log(AMap)
            resolve(AMap)
        })
   })
        
}