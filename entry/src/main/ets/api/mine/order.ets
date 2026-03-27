import httpRequest from "../../utils/request"
import { ApiResponse, NoApi } from "../../viewModel"
import { OrderDetail, OrderGoodsItem, OrderSubmit, OrderSubmitParams } from "../../viewModel/mine/order"


// 提交订单
export const submitOrder = (data: OrderSubmitParams): Promise<ApiResponse<OrderSubmit>> => {
  return httpRequest.post('order/submit', data)
}

// 获取订单详情
export const getOrderDetail = (orderId: number): Promise<ApiResponse<OrderDetail>> => {
  return httpRequest.get('order/detail', { params: { orderId } })
}

// 取消订单
export const cancelOrder = (orderId: number): Promise<NoApi> => {
  return httpRequest.post('order/cancel', orderId )
}

// 获取订单列表
export const getOrderList = (
  showType: number = 0,
  page: number = 1,
  limit: number = 10
): Promise<ApiResponse<OrderGoodsItem>> => {
  return httpRequest.get('order/list', {
    params: { showType, page, limit }
  })
}