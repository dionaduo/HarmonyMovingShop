import { GoodsItem } from "../goods/goods";
import { Banner, Brand, Channel, Coupon, Floor, Groupon, Topic } from "./IHomeData";

export interface HomePageData{
  banners:  Banner[];
  brands:  Brand[];
  channels:  Channel[];
  coupons:  Coupon[];
  floors:  Floor[];
  groupons:  Groupon[];
  hotGoods: GoodsItem[];
  newGoods: GoodsItem[];
  topics:  Topic[];
}


