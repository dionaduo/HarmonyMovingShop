// IHomeData.ets （精简版）
import { GoodsItem } from "../goods/goods";

// Banner（基本不变，但字段排序更直观）
export interface Banner {
  id: number;
  name: string;
  link: string;
  url: string;
  position: number;
  content: string;
  enabled: boolean;
  addTime: string;
  updateTime: string;
  deleted: boolean;
}

// 品牌
export interface Brand {
  id: number;
  name: string;
  desc: string;
  picUrl: string;
  floorPrice: number;
}

// 频道/分类导航
export interface Channel {
  id: number;
  name: string;
  iconUrl: string;
}

// 优惠券
export interface Coupon {
  id: number;
  name: string;
  desc: string;
  tag: string;
  discount: number;
  min: number;
  days: number;
}

// 楼层商品（最常见结构）
export interface Floor {
  id: number;
  name: string;
  goodsList: GoodsItem[];
}

// 团购
export interface Groupon {
  id: number;
  name: string;
  brief: string;
  picUrl: string;
  counterPrice: number;
  retailPrice: number;
  grouponPrice: number;
  grouponDiscount: number;
  grouponMember: number;
  expireTime: string;
}

// 专题
export interface Topic {
  id: number;
  title: string;
  subtitle: string;
  price: number;
  readCount: string;
  picUrl: string;
}

