import httpRequest from "../../utils/request";
import { ApiResponse } from "../../viewModel";
import { GoodsDetailData } from "../../viewModel/goods/goodsDetail";

/**
 * 获取商品详情
 * @param id 商品ID
 */
export const getGoodsDetail = (
  id: number
): Promise<ApiResponse<GoodsDetailData>> => {
  return httpRequest.get("goods/detail", { params:{id} });
};