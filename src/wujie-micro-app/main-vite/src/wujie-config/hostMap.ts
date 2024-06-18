const map:any = {
  // "//localhost:5100/": "//wujie-micro.github.io/demo-vite/",
  "//localhost:5100/": "//localhost:5100/",
  "demo-vite": "//localhost:5100/",
  "wujie-micro": "//wujie-micro.github.io/demo-vite/",
};

const map_production:any = {
  // "//localhost:5100/": "//wujie-micro.github.io/demo-vite/",
  "//localhost:5100/": "//localhost:5100/",
  "demo-vite": "//localhost:5100/",
  "wujie-micro": "//wujie-micro.github.io/demo-vite/",
};

export default function hostMap(host:string) {

  console.log(process.env.NODE_ENV)
  console.log('map[host]',map[host])

  if (process.env.NODE_ENV === "production"){
    console.log('map[host]',map_production[host])
    return map_production[host];
  }
  return map[host];
}
