import { GoodsItem } from "../goods/goods";

// 主分类（L1）
export interface CategoryL1 {
  id: number;
  name: string;
  keyword: string;
  desc: string;
  pid: number;
  iconUrl: string;
  picUrl: string;
  level: string; // "L1"
  sortOrder: number;
  addTime: string;
  updateTime: string;
  deleted: boolean;
}

// 子分类（L2）
export interface CategoryL2 {
  id: number;
  name: string;
  keywords: string;
  desc: string;
  pid: number; // 父级 id
  iconUrl: string;
  picUrl: string;
  level: string; // "L2"
  sortOrder: number;
  addTime: string;
  updateTime: string;
  deleted: boolean;
}

// 分类首页（所有一级 + 当前一级 + 其子分类）
export interface CategoryData {
  currentCategory: CategoryL1;
  // 所有一级分类
  categoryList: CategoryL1[];
}

// 当前分类详情（点击一级分类时返回的数据）
export interface CurrentCategoryData {
  currentCategory: CategoryL1;
  // 该一级下的所有二级分类
  currentSubCategory: CategoryL2[];
}

// 子分类详情（当前子分类 + 同级兄弟子分类 + 父级分类）
export interface SubCategoryDetail {
  currentCategory: CategoryL2; // 当前选中的子分类 (L2)
  brotherCategory: CategoryL2[]; // 同父级下的其他兄弟子分类
  parentCategory: CategoryL1; // 父级一级分类
}

// 子分类商品列表分页响应
export interface PageList<T> {
  total: number; // 总记录数
  pages: number; // 总页数
  limit: number; // 每页条数
  page: number; // 当前页码
  filterCategoryList?: CategoryL2[]; // 筛选的分类列表
  list: T[]; // 商品列表
}

// 方便组件使用的联合类型（可选）
export type Category = CategoryL1 | CategoryL2;