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
  cartId: string  // 多个cartId用逗号分隔,如 "1,2,3"
  addressId?: number
  couponId?: number
  userCouponId?: number
  grouponRulesId?: number
}

export interface Checkout {
  grouponRulesId: number
  actualPrice: number
  orderTotalPrice: number
  cartId: number
  userCouponId: number
  couponId: number
  goodsTotalPrice: number
  addressId: number
  grouponPrice: number
  checkedAddress: AddressItem
  couponPrice: number
  availableCouponLength: number
  freightPrice: number
  checkedGoodsList: CartItem[]
}

export interface AddressItem {
  id: number
  name: string
  userId: number
  province: string
  city: string
  county: string
  addressDetail: string
  areaCode: string
  postalCode: string
  tel: string
  isDefault: boolean
  addTime: string
  updateTime: string
  deleted: boolean
}

export  interface AddCart{
cartId:number,
cartTotal:CartTotal
}