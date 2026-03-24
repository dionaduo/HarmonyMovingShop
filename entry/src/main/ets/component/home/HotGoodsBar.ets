import { GoodsItem } from '../../viewModel/goods/goods'
import { window } from '@kit.ArkUI'
import { getHomeData } from '../../api/home'
import { goods } from '../common/goods'
import { header } from '../common/header'

@Component
export struct HotGoodsBar{
  @State hotGoods: Array<GoodsItem> = []

  aboutToAppear(): void {
    this.getCoupon()
    window.getLastWindow(this.getUIContext().getHostContext()).then((win) => {
      win.setWindowLayoutFullScreen(true).catch((err: string) => {
        console.log(err)
      })
    })
  }

  private async getCoupon() {
    try {
      const res = await getHomeData()
      this.hotGoods = res.data.hotGoodsList
      console.log(JSON.stringify(this.hotGoods))
    } catch (err) {
      console.error(err)
    }
  }

  build() {
    Column(){
      header({
        head:'人气推荐',
        moreHead:'更多人气推荐'
      })
      List(){
        ForEach(this.hotGoods,(item:GoodsItem,index:number)=>{
          ListItem(){
            goods({
              goodsImage: item.picUrl,
              goodTitle: item.name,
              goodsDesc:item.brief,
              goodsCurPrice:item.counterPrice,
              goodsRealPrice:item.retailPrice
            })
          }
        })
      }.width('100%').height(560).padding({top:3})
    }.width('100%').padding(10)
  }
}