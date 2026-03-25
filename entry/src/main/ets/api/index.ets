import { getHomeData } from './home';
import { ApiResponse, HomeData } from '../viewModel';

// ====================== 内部静态提取函数 ======================
function getFieldData<T>(data: HomeData, field: keyof HomeData): Array<T> {
  switch (field) {
    case 'banner':
      return data.banner as Array<T>;
    case 'brandList':
      return data.brandList as Array<T>;
    case 'channel':
      return data.channel as Array<T>;
    case 'couponList':
      return data.couponList as Array<T>;
    case 'floorGoodsList':
      return data.floorGoodsList as Array<T>;
    case 'grouponList':
      return data.grouponList as Array<T>;
    case 'hotGoodsList':
      return data.hotGoodsList as Array<T>;
    case 'newGoodsList':
      return data.newGoodsList as Array<T>;
    case 'topicList':
      return data.topicList as Array<T>;
    default:
      console.warn(`未知字段: ${String(field)}`);
      return [];
  }
}

// ====================== 简化的通用加载函数 ======================
export async function loadData<T>(
  target: Array<T>,
  field: keyof HomeData
): Promise<Array<T>> {
  try {
    const response: ApiResponse<HomeData> = await getHomeData();
    const dataList: Array<T> = getFieldData<T>(response.data, field);
    target.splice(0, target.length, ...dataList);
    return dataList;
  } catch (err) {
    console.error(`加载 ${String(field)} 数据失败:`, err);
    target.length = 0;
    return [];
  }
}