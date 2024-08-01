const map:any = {
  "langflow-api": "http://127.0.0.1:7860/api/v1",
  "workflow-api": "http://127.0.0.1:7860/api/v2",
  "langflow": "http://localhost:7860/langflow/",
  "demo-vite": "//localhost:5100/",
  "wujie-micro": "//wujie-micro.github.io/demo-vite/",
};

const map_production:any = {
  "langflow-api": "/api/v1",
  "workflow-api": "/api/v2",
  "langflow": "/langflow/",
  "demo-vite": "//localhost:5100/",
  "wujie-micro": "//wujie-micro.github.io/demo-vite/",
};

export default function hostMap(host:string) {

  if (process.env.NODE_ENV === "production"){
    //console.log('map[host]',map_production[host])
    return map_production[host];
  }
  //console.log('map[host]',map[host])
  return map_production[host];
}
