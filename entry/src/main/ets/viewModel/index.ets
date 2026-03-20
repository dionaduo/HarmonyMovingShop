import {HomePageData} from './home/index'
export interface ApiResponse<T> {
  errno: number,
  errmsg: string,
  data: T,
}

export type HomeData = HomePageData;