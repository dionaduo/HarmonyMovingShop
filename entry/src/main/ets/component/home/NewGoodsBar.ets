import { GoodsItem } from "../../viewModel/goods/goods"
import { window } from "@kit.ArkUI"
import { header } from "../common/header"
import { loadData } from "../../api"

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

  build() {
    Column() {
      header({
        head: '新品首发',
        moreHead: '更多新品首发'
      })
      Grid() {
        ForEach(this.newGoods, (item: GoodsItem, index: number) => {
          GridItem() {
            Column() {
              Image(item.picUrl)
                .objectFit(ImageFit.Contain)
                .borderRadius(10)
                .height(100)

              Text(item.name)
                .fontSize(12)
                .fontColor(Color.Black)
                .fontWeight('bold')
              Text('$ '+item.retailPrice)
                .fontSize(10)
                .padding(2)
                .fontColor(Color.Red)
            }
            .width('100%')
            .height(130)
            .border({
              width:1,
              style: BorderStyle.Solid,
              color: Color.Gray
            })
            .borderRadius(5)
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