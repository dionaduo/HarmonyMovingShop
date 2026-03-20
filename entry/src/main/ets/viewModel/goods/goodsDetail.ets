// types/goodsDetail.ets

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

// 商品属性参数（材质、克重、填充物等）
export interface Attribute {
  id: number;
  goodsId: number;
  attribute: string; // 属性名，如 "材质"、"填充"
  value: string; // 属性值
  addTime: string;
  updateTime: string;
  deleted: boolean;
}

// 评论概览（当前数据中为空数组，但保留结构）
export interface CommentSummary {
  data: never[]; // 当前接口返回空数组，暂不定义具体评论项类型
  count: number;
}

// 商品基本信息（info 对象）
export interface GoodsInfo {
  id: number;
  name: string;
  goodsSn: string;
  categoryId: number;
  brandId: number;
  goodsNumber: number;
  keywords: string;
  brief: string;
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
  groupon: never[]; // 暂为空，未来可扩展 Groupon 类型

  // 常见问题列表
  issue: Issue[];

  // 当前用户是否收藏该商品（0=未收藏，1=已收藏）
  userHasCollect: 0 | 1;

  // 分享图片（当前为空字符串）
  shareImage: string;

  // 是否支持分享（当前为 true）
  share: boolean;

  // 商品参数属性列表
  attribute: Attribute[];

  // 评论统计
  comment: CommentSummary;
}

// 方便组件/页面使用的简写类型
export type GoodsDetail = GoodsDetailData;