import { getGoodsDetail } from '../../api/goods';
import { goodsDetail } from '../../component/goods/goodsDetail';
import { GoodsDetailData } from '../../viewModel/goods/goodsDetail';

@Entry
@Component
struct GoodsDetailPage {
  @State goodsId: number = 1181000;
  @State detailData: GoodsDetailData = {} as GoodsDetailData;

  async aboutToAppear() {
    try {
      const res = await getGoodsDetail(1181000)
      this.detailData = res.data
      console.log('这是Page的数据:'+JSON.stringify(this.detailData))
    } catch (err) {
      console.error('在GoodsPage中发送错误:'+err)
    }
  }

  build() {
    Column(){
      if (!this.detailData || !this.detailData.info){
        Column(){
          Text('正在加载中...')
        }
      } else {
        goodsDetail({ detail: this.detailData })
      }
    }
    .height('100%')
    .width('100%')
  }
}