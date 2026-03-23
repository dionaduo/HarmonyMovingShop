import { Groupon } from '../../viewModel/home/IHomeData'
import { window } from '@kit.ArkUI'
import { getHomeData } from '../../api/home'
import { header } from '../common/header'

@Component
export struct GrouponBar {
  @State groupon: Array<Groupon> = []

  aboutToAppear(): void {
    this.getGroupon()
    window.getLastWindow(this.getUIContext().getHostContext()).then((win) => {
      win.setWindowLayoutFullScreen(true).catch((err: string) => {
        console.log(err)
      })
    })
  }

  private async getGroupon() {
    try {
      const res = await getHomeData()
      this.groupon = res.data.grouponList
      console.log(JSON.stringify(this.groupon))
    } catch (err) {
      console.error(err)
    }
  }

  @Builder
  buildGrouponItem(item: Groupon) {
    Row({ space: 8 }) {
      // 图片区域
      Image(item.picUrl)
        .objectFit(ImageFit.Contain)
        .width('30%')
        .height('100%')
        .borderRadius(8)

      // 右侧信息区
      Column({ space: 6 }) {
        Text(item.name)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textAlign(TextAlign.Start)
          .width('100%')

        Text(item.brief)
          .fontSize(12)
          .fontColor(Color.Gray)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textAlign(TextAlign.Start)
          .width('100%')


        // 标签行
        Row({ space: 8 }) {
          Text(`${item.grouponDiscount}人成团`)
            .fontSize(12)
            .fontColor(Color.Blue)
            .padding(2)
            .border({ width: 1, color: Color.Blue, radius: 4 })
            .textAlign(TextAlign.Start)

          Text(`${item.grouponMember}元立减`)
            .fontSize(12)
            .fontColor(Color.Red)
            .padding(2)
            .border({ width: 1, color: Color.Red, radius: 4 })
            .textAlign(TextAlign.Start)

        }.justifyContent(FlexAlign.Start).width('100%')

        // 价格行
        Row({ space: 8}) {
          Text(`￥${item.grouponPrice}`)
            .fontSize(16)
            .fontColor(Color.Red)
            .fontWeight(FontWeight.Bold)


          Text(`￥${item.retailPrice}`)
            .fontSize(13)
            .fontColor(Color.Gray)
            .decoration({ type: TextDecorationType.LineThrough }) // 删除线更专业
        }.justifyContent(FlexAlign.Start).width('100%')
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Start)
      .padding(2)
    }

    .width('100%')
    .padding(8)
    .border({ width: 1, color: Color.Red, radius: 8 })
    .backgroundColor(Color.White)
  }

  build() {
    Column(){
      header({
        head:'团购专区',
        moreHead:'更多团购商品'
      })

      Row(){
        ForEach(this.groupon, (item: Groupon, index: number) => {
          this.buildGrouponItem(item);
        })
      }.height(110).padding({top:5})
    }.width('100%').padding(10)
  }
}