import { GoodsItem } from "../../viewModel/goods/goods"
import { window } from "@kit.ArkUI"
import { getHomeData } from "../../api/home"
import { header } from "../common/header"

@Component
export struct NewGoodsBar {

  @State newGoods: Array<GoodsItem> = []

  aboutToAppear(): void {
    this.getNewGoods()
    window.getLastWindow(this.getUIContext().getHostContext()).then((win) => {
      win.setWindowLayoutFullScreen(true).catch((err: string) => {
        console.log(err)
      })
    })
  }

  private async getNewGoods() {
    try {
      const res = await getHomeData()
      this.newGoods = res.data.newGoodsList
      console.log(JSON.stringify(this.newGoods))
    } catch (err) {
      console.error(err)
    }
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
              Text('$'+item.retailPrice)
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
          }
        })
      }.rowsGap(3)
      .columnsGap(3)
      .width('100%')
      .height(380)
      .rowsTemplate('repeat(3,1fr)')
      .columnsTemplate('repeat(2, 1fr)')
    }.width('100%')
    .padding(10)
  }
}