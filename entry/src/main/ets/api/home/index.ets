import { httpRequest } from "../../utils/request"
import { PageList } from "../../viewModel/category/catalog"
import { GoodsItem } from "../../viewModel/goods/goods"
import { Brand } from "../../viewModel/goods/goodsDetail"
import { ApiResponse, HomeData } from "../../viewModel/index"

export const getHomeData=(): Promise<ApiResponse<HomeData>> =>{
      return httpRequest.get('home/index')
}

export const getBrandGoodsById=(brandId:number):Promise<ApiResponse<PageList<GoodsItem>>> =>{
	return httpRequest.get('goods/list',{params:{ brandId}})
}
export const getBrandById = (id: number): Promise<ApiResponse<Brand>> => {
	return httpRequest.get('brand/detail', { params: { id } })
}

export  const searchGoods = (keyword:string,page:number=1,limit:number=30,categoryId:number=0): Promise<ApiResponse<PageList<GoodsItem>>> => {
	return httpRequest.get('goods/list', { params: { keyword, page, limit ,categoryId} })
}
