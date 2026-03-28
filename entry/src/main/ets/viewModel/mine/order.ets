// api/order/order.ts
export interface OrderSubmitParams {
  cartId: number
  addressId: number
  couponId?: number
  userCouponId?: number
  grouponRulesId?: number
  grouponLinkId?: number
  message?: string
}

export interface OrderSubmit {
    orderId: number
    grouponLinkId: number
    payed: boolean
}

export interface HandleOption {
  cancel: boolean
  delete: boolean
  pay: boolean
  comment: boolean
  confirm: boolean
  refund: boolean
  rebuy: boolean
  aftersale: boolean
}

export interface OrderInfo {
  consignee: string
  address: string
  addTime: string
  orderSn: string
  actualPrice: number
  mobile: string
  message: string
  orderStatusText: string
  aftersaleStatus: number
  goodsPrice: number
  couponPrice: number
  id: number
  freightPrice: number
  handleOption: HandleOption
}

export interface OrderGoodsItem {
  id: number
  orderId: number
  goodsId: number
  goodsName: string
  goodsSn: string
  productId: number
  number: number
  price: number
  specifications: string[]
  picUrl: string
  comment: number
  addTime: string
  updateTime: string
  deleted: boolean
}

export interface OrderDetail {
    expressInfo: OrderGoodsItem[]
    orderInfo: OrderInfo
    orderGoods: OrderGoodsItem[]
}

export interface OrderPay {
    paySign?: string
    timestamp?: string
    nonceStr?: string
    prepayId?: string
    signType?: string
    package?: string
    payUrl?: string
    mwebUrl?: string
}

export interface OrderListItem {
  orderStatusText: string
  aftersaleStatus: number
  isGroupin: boolean
  orderSn: string
  actualPrice: number
  goodsList: OrderGoodsItem[]
  id: number
  handleOption: HandleOption
}

export interface OrderListData {
  total: number
  pages: number
  limit: number
  page: number
  list: OrderListItem[]
}
