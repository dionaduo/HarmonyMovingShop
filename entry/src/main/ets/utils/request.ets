import axios, { AxiosError, AxiosResponse, AxiosResponseTransformer, InternalAxiosRequestConfig } from '@ohos/axios'

export const httpRequest = axios.create({
  baseURL: 'http://hmapp.net:8080/wx/',
  timeout:10000
})

//请求拦截器
httpRequest.interceptors.request.use((config: InternalAxiosRequestConfig)=>{
  return config
},(err:AxiosError)=>{
  return Promise.reject('请求拦截数据失败:'+err)
})
//响应拦截器

httpRequest.interceptors.response.use((res:AxiosResponse)=>{
  return res.data
},(err:AxiosError)=>{
  return Promise.reject('响应拦截数据失败'+err)
})

export default httpRequest;