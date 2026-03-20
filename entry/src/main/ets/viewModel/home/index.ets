import { GoodsItem } from "../goods/goods";
import { Banner, Brand, Channel, Coupon, Floor, Groupon, Topic } from "./IHomeData";

export interface HomePageData{
  banner:  Banner[];
  brands:  Brand[];
  channels:  Channel[];
  coupons:  Coupon[];
  floors:  Floor[];
  groupons:  Groupon[];
  hotGoods: GoodsItem[];
  newGoods: GoodsItem[];
  topics:  Topic[];
}
