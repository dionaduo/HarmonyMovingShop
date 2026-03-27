
export interface CollectItem {
  id: number
  goodsId: number
  goodsName: string
  picUrl: string
  brief?: string
  retailPrice: number
}

export interface OrderParams {
  showType?: number;
  page: number;
  limit: number;
}

export interface IssueItem {
  id: number;
  question: string;
  answer: string;
}

export interface FeedbackData {
  type: number;
  content: string;
  contact?: string;
}

// 登录请求参数接口
export interface LoginParams {
  username: string;
  password: string;
}

// 登录响应数据接口
interface loginUser {
  nickName: string;
  avatarUrl: string;
}

export interface TokenInfo {
  token: string;
  userInfo: loginUser;
}
