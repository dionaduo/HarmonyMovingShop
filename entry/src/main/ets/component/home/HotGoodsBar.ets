import { GoodsItem } from '../../viewModel/goods/goods'
import { window } from '@kit.ArkUI'
import { getHomeData } from '../../api/home'
import { goods } from '../goods/goods'
import { header } from '../common/header'
import { loadData } from '../../api'

@Component
export struct HotGoodsBar{
  @State hotGoods: Array<GoodsItem> = []

  async aboutToAppear(): Promise<void> {
    this.hotGoods = await loadData(this.hotGoods, 'hotGoodsList');
  }
  private hotGoodsRouter = this.getUIContext().getRouter()


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
            }).onClick(()=>{
              this.hotGoodsRouter.pushUrl({
                url: 'view/goods/GoodsDetailPage',
                params: { id:item.id } as GoodsItem
              }).catch((err: string) => {
                console.log('跳转失败,错误信息:'+ err)
              })
            })
          }
        })
      }
      .scrollBar(BarState.Off)
      .width('100%').height(300).padding({top:3})
    }

    .width('100%').padding(10)
  }
}