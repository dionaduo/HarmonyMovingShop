import { Groupon } from "../home/IHomeData";

// 商品规格项的值
export interface SpecificationValue {
  id: number;
  goodsId: number;
  specification: string; // 如 "规格"、"颜色"
  value: string; // 如 "1.5m床垫*1+枕头*2"、"浅杏粉"
  picUrl: string; // 颜色规格通常有图片，普通规格可能为空字符串
  addTime: string;
  updateTime: string;
  deleted: boolean;
}

// 商品的一个规格组（例如：规格、颜色、尺寸等）
export interface SpecificationGroup {
  name: string; // 如 "规格"、"颜色"
  valueList: SpecificationValue[]; // 该组下的所有可选值
}

// 常见问题 / FAQ 条目
export interface Issue {
  id: number;
  question: string;
  answer: string;
  addTime: string;
  updateTime: string;
  deleted: boolean;
}

// 商品属性参数（规格、重要提醒等）
export interface Attribute {
  id: number;
  goodsId: number;
  attribute: string; // 属性名，如 "规格"、"重要提醒"
  value: string; // 属性值
  addTime: string;
  updateTime: string;
  deleted: boolean;
}

// 评论条目
export interface CommentItem {
  addTime: string;
  picList: string[];
  adminContent: string;
  nickname: string;
  id: number;
  avatar: string;
  content: string;
}

// 评论数据
export interface CommentData {
  data: CommentItem[];
  count: number;
}

// 品牌信息
export interface Brand {
  id: number;
  name: string;
  desc: string;
  picUrl: string;
  sortOrder: number;
  floorPrice: number;
  addTime: string;
  updateTime: string;
  deleted: boolean;
}

// 商品规格组合（SKU）
export interface Product {
  id: number;
  goodsId: number;
  specifications: string[]; // [规格值, 颜色值]
  price: number;
  number: number; // 库存数量
  url: string;
  addTime: string;
  updateTime: string;
  deleted: boolean;
}

// 商品基本信息（info 对象）
export interface GoodsInfo {
  id: number;
  name: string;
  goodsSn: string;
  categoryId: number;
  brandId: number;
  gallery: string[]; // 商品轮播图
  keywords: string;
  brief: string; // 商品简介
  isOnSale: boolean;
  sortOrder: number;
  picUrl: string; // 主图
  shareUrl?: string; // 可选，分享链接
  isNew: boolean;
  isHot: boolean;
  unit: string; // 单位，如 "件"、"套"
  counterPrice: number; // 划线价
  retailPrice: number; // 实际售价
  detail: string; // 商品详情富文本 HTML（包含多张图片）
  addTime: string;
  updateTime: string;
  deleted: boolean;
}

// 完整的商品详情响应 data 部分
export interface GoodsDetailData {
  // 商品核心信息
  info: GoodsInfo;

  // 规格列表（可能有多个组：规格、颜色、尺寸等）
  specificationList: SpecificationGroup[];

  // 团购信息（当前数据中为空数组）
  groupon: Groupon[];

  // 常见问题列表
  issue: Issue[];

  // 当前用户是否收藏该商品（0=未收藏，1=已收藏）
  userHasCollect: 0 | 1;

  // 分享图片（当前为空字符串）
  shareImage: string;

  // 是否支持分享
  share: boolean;

  // 商品参数属性列表
  attribute: Attribute[];

  // 品牌信息
  brand: Brand;

  // SKU 列表（规格组合）
  productList: Product[];

  // 评论统计
  comment: CommentData;
}

// 方便组件/页面使用的简写类型
export type GoodsDetail = GoodsDetailData;