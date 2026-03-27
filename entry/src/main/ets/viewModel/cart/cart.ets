// api/cart/cart.ts
export interface CartItem {
  id: number
  userId: number
  goodsId: number
  goodsSn: string
  goodsName: string
  productId: number
  price: number
  number: number
  specifications: string[]
  checked: boolean
  picUrl: string
  shopId?: string
  shopName?: string
  stock?: number
  addTime: string
  updateTime: string
  deleted: boolean
}

export interface CartTotal {
  goodsCount: number
  goodsAmount: number
  checkedGoodsCount: number
  checkedGoodsAmount: number
}

export interface CartList {
    cartList: CartItem[]
    cartTotal: CartTotal
}

export interface UpdateCartParams {
  id: number
  number: number
  goodsId: number
  productId: number
}

export interface DeleteCartParams {
  productIds: number[]
}

export interface CheckoutParams {
  cartIds: string
  addressId?: number
  couponId?: number
}

export interface Checkout {
    orderTotalPrice: number
    goodsTotalPrice: number
    freightPrice: number
    couponPrice: number
    actualPrice: number
    checkedGoodsList: CartItem[]
    checkedAddress: string
    availableCouponLength: number

}

export  interface AddCart{
cartId:number,
cartTotal:CartTotal
}