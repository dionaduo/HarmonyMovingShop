import { GoodsItem } from "../../viewModel/goods/goods"
import { window } from "@kit.ArkUI"
import { header } from "../common/header"
import { loadData } from "../../api"
import { lineGoods } from "../goods/lineGoods"

@Component
export struct NewGoodsBar {
  @State newGoods: Array<GoodsItem> = []
  async aboutToAppear(): Promise<void> {
    this.newGoods = await loadData(this.newGoods, 'newGoodsList');
    window.getLastWindow(this.getUIContext().getHostContext()).then((win) => {
      win.setWindowLayoutFullScreen(true).catch((err: string) => {
        console.log(err)
      })
    })
  }

  private hotGoodsRouter = this.getUIContext().getRouter()

  build() {
    Column() {
      header({
        head: '新品首发',
        moreHead: '更多新品首发'
      })
      Grid() {
        ForEach(this.newGoods, (item: GoodsItem, index: number) => {
          GridItem() {
            lineGoods({
              picUrl:item.picUrl,
              name:item.name,
              retailPrice:item.retailPrice
            })
            .onClick(() => {
              this.hotGoodsRouter.pushUrl({
                url: 'view/goods/GoodsDetailPage',
                params: { id: item.id } as GoodsItem
              }).catch((err: string) => {
                console.log('跳转失败,错误信息:' + err)
              })
            })
          }
        })
      }.rowsGap(3)
      .columnsGap(3)
      .width('100%')
      .height(420)
      .rowsTemplate('repeat(3,1fr)')
      .columnsTemplate('repeat(2, 1fr)')
    }.width('100%')
    .padding(10)
  }
}