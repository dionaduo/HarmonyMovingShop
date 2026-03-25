import { getGoodsDetail } from '../../api/goods';
import { goodsDetail } from '../../component/goods/goodsDetail';
import { GoodsDetailData } from '../../viewModel/goods/goodsDetail';
import { window } from '@kit.ArkUI';
import { GoodsItem } from '../../viewModel/goods/goods';

@Entry
@Component
struct GoodsDetailPage {
  @State detailData: GoodsDetailData = {} as GoodsDetailData;
  private goodsRouter = this.getUIContext().getRouter()

  async aboutToAppear() {
    window.getLastWindow(this.getUIContext().getHostContext()).then((win)=>{
      win.setWindowLayoutFullScreen(true)
    })
    let goodsId = (this.goodsRouter.getParams() as GoodsItem).id
    try {
      const res = await getGoodsDetail(goodsId)
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