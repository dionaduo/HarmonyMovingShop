import { httpRequest } from "../../utils/request"
import { ApiResponse, HomeData } from "../../viewModel/index"

export const getHomeData=(): Promise<ApiResponse<HomeData>> =>{
      return httpRequest.get('home/index')
}
