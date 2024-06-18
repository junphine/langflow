// 携带登录态credentials必须为include
export default function fetch(url?:any, options?:any) {
  console.log('============')
  console.log(url)
  console.log()
  // console.log('window.fetch(url, { ...options, credentials: "omit" })',window.fetch(url, { ...options, credentials: "omit" }))
  return window.fetch(url );
  return window.fetch(url, { ...options, credentials: "omit" });
}
