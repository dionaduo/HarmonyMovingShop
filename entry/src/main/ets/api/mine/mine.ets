import httpRequest from "../../utils/request";
import { ApiResponse } from "../../viewModel";
import { AddressItem } from "../../viewModel/address/address";
import { PageList } from "../../viewModel/category/catalog";
import { CollectItem, FeedbackData, IssueItem, LoginParams, OrderParams, TokenInfo } from "../../viewModel/mine/mine";
import { OrderGoodsItem } from "../../viewModel/mine/order";
import { UserInfo } from "../../viewModel/mine/user";

/**
 * 获取用户信息
 */
export const getUserInfo = (): Promise<ApiResponse<UserInfo>> => {
  return httpRequest.get('user/index')
};

/**
 * 获取收藏列表
 */
export const getCollectList = (params: OrderParams): Promise<ApiResponse<PageList<CollectItem>>> => {
  return httpRequest.get('/collect/list', {
    params: {
      type: params.showType !== undefined ? params.showType : 0,
      page: params.page,
      limit: params.limit
    }
  });
};

/**
 * 删除收藏
 */
export const deleteCollect = (valueId: number): Promise<ApiResponse<null>> => {
  const requestData: number = valueId;
  return httpRequest.post('/collect/delete', requestData);
};

/**
 * 获取常见问题列表
 */
export const getIssueList = (page:number,limit:number,keyword:string): Promise<ApiResponse<PageList<IssueItem>>> => {
  return httpRequest.get('/issue/list', { params: { page: page, limit: limit, keyword: keyword } });
};


/**
 * 提交意见反馈
 */

export const submitFeedback = (params: FeedbackData): Promise<ApiResponse<null>> => {
  return httpRequest.post('/feedback/submit', params);
};

/**
 * 退出登录
 */
export const logout = (): Promise<ApiResponse<null>> => {
  return httpRequest.post('/auth/logout');
};

/**
 * 用户登录
 */
export const login = (params: LoginParams): Promise<ApiResponse<TokenInfo>> => {
  return httpRequest.post('wx/auth/login', params);
};