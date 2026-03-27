import {HomePageData} from './home/index'
export interface ApiResponse<T> {
  errno: number,
  errmsg: string,
  data: T,
}

export interface NoApi {
  errno: number;
  errmsg: string;
}

export type HomeData = HomePageData;

export function createDefaultHomeData(): HomePageData {
  return {
    banner: [],
    brandList: [],
    channel: [],
    couponList: [],
    floorGoodsList: [],
    grouponList: [],
    hotGoodsList: [],
    newGoodsList: [],
    topicList: []
  };
}