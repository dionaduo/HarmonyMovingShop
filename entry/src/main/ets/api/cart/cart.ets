import httpRequest from "../../utils/request";
import { ApiResponse, NoApi } from "../../viewModel";
import {
  AddCart,
  CartList, Checkout, CheckoutParams, DeleteCartParams, UpdateCartParams } from "../../viewModel/cart/cart";

export const getCartList = (): Promise<ApiResponse<CartList>> => {
  return httpRequest.get('cart/index')
}

export const updateCart = (data: UpdateCartParams): Promise<NoApi> => {
  return httpRequest.post('cart/update', data)
}

export const deleteCart = (data: DeleteCartParams): Promise<ApiResponse<CartList>> => {
  return httpRequest.post('cart/delete', data)
}

export const checkoutCart = (params: CheckoutParams): Promise<ApiResponse<Checkout>> => {
  return httpRequest.get('cart/checkout', { params })
}

/**
 * 获取购物车商品数量
 */
export const getCartCount = (): Promise<ApiResponse<number>> => {
  console.log('【API】getCartCount');
  return httpRequest.get('/cart/goodscount');
};

export interface addCartParams {
  goodsId: number;
  productId: number;
  number: number;
}

/**
 * 加入购物车
 * @param data 加入购物车参数
 * @description POST请求 - 将商品加入购物车
 */

export const addToCart = (data: addCartParams): Promise<ApiResponse<addCartParams>> => {
  return httpRequest({
    url: 'cart/add',
    method: 'POST',
    data
  })
}

interface CartID {
  cartId: number;
}


/**
 * 立即购买（快速加入购物车）
 * @param data 立即购买参数
 * @description POST请求 - 直接购买，快速加入购物车并跳转结算
 */
export const fastAddToCart = (data: addCartParams): Promise<ApiResponse<number>> => {
  return httpRequest({
    url: 'cart/fastadd',
    method: 'POST',
    data
  })
}

