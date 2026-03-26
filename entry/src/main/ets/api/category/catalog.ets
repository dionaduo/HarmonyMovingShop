// api/catalog.ts
import { httpRequest } from "../../utils/request"; // 复用你已有的工具
import { ApiResponse } from "../../viewModel";
import { CategoryData, CurrentCategoryData, SubCategoryDetail,
  PageList } from "../../viewModel/category/catalog";
import { GoodsItem } from "../../viewModel/goods/goods";

// 获取分类首页数据（所有一级分类 + 当前默认一级）
export const getCategory = (): Promise<ApiResponse<CategoryData>> => {
  return httpRequest.get('catalog/index');
};

// 获取指定一级分类的详情（包括其子分类）
export const getCurrentCategory = (id: number): Promise<ApiResponse<CurrentCategoryData>> => {
  return httpRequest.get('catalog/current', { params: { id } });
};

// 获取子分类详情（当前子分类 + 兄弟分类 + 父分类）
export const getSubCategoryDetail = (
  id: number
): Promise<ApiResponse<SubCategoryDetail>> => {
  return httpRequest.get("goods/category", { params:{id } });
};

// 获取子分类下的商品列表（分页）
export interface subCategoryInterface { categoryId: number;page: number;limit: number; }

export const getSubCategoryGoods = (params: subCategoryInterface): Promise<ApiResponse<PageList<GoodsItem[]>>> => {
  return httpRequest.get("goods/list", { params });
};