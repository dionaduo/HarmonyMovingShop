import { GoodsItem } from "../goods/goods";
import { Banner, Brand, Channel, Coupon, Floor, Groupon, Topic } from "./IHomeData";

export interface HomePageData{
  banner:  Banner[];
  brandList:  Brand[];
  channel:  Channel[];
  couponList:  Coupon[];
  floorGoodsList:  Floor[];
  grouponList:  Groupon[];
  hotGoodsList: GoodsItem[];
  newGoodsList: GoodsItem[];
  topicList:  Topic[];
}
