export interface GoodsBase {
  id: number;
  name: string;
  brief: string;
  picUrl: string;
  counterPrice: number; // 划线价 / 原价
  retailPrice: number; // 实际售价
}

export interface GoodsItem extends GoodsBase {
  isNew: boolean;
  isHot: boolean;
}