import { TabContentBuilder } from "@kit.ArkUI";

interface ITitle {
  title: string;
  color: Color;
}

@Component
export struct tabBarComponent {
  @State curTabIndex: number = 0
  @State currTabImage: Resource[] = [
    $r('app.media.MF'),
    $r('app.media.MU'),
    $r('app.media.MC'),
    $r('app.media.MK'),
    $r('app.media.wxts')
  ]
  @State titleList: ITitle[] = [
    { title: '精选', color: Color.Red },
    { title: '推荐', color: Color.Blue },
    { title: '收藏', color: Color.Green },
    { title: '更多', color: Color.Orange }
  ]

  @Builder
  tabItem(index: number, title: string, icon: Resource, selectedIcon: Resource) {
    Column() {
      Image(index == this.curTabIndex ? selectedIcon : icon).width(20)
      Divider()
        .width(35)
        .strokeWidth(3)
        .margin({ top: 3, bottom: 3 })
        .backgroundColor(index == this.curTabIndex ? Color.Red : Color.Transparent)
      Text(title).fontSize(16).fontColor(index == this.curTabIndex ? Color.Red : Color.Black).padding({ bottom: 30 })
    }
  }

  @Builder NotFound(title:string) {
    Column(){
      Text('空空如也,请重新加载....').fontSize(16).fontColor(Color.Red);
      Divider()
      Text(title)
    }.width('100%')
  }

  @BuilderParam homeContent: () => void
  @BuilderParam recommendContent: () => void
  @BuilderParam favoriteContent: () => void
  @BuilderParam moreContent: () => void

  // 可选：默认占位 builder（统一处理未传的情况）
  @LocalBuilder
  defaultPlaceholder(title: string) {
    Column() {
      Text('该 Tab 内容尚未提供')
        .fontSize(18)
        .fontColor(Color.Gray)
      Text(title)
        .fontSize(14)
        .fontColor(Color.Gray)
        .margin({ top: 12 })
    }.width('100%').height('100%').justifyContent(FlexAlign.Center)
  }

  build() {
    Tabs() {
      ForEach(this.titleList, (item: ITitle, index: number) => {
        TabContent() {
          if (index === 0 && this.homeContent) {
            this.homeContent()
          } else if (index === 1 && this.recommendContent) {
            this.recommendContent()
          } else if (index === 2 && this.favoriteContent) {
            this.favoriteContent()
          } else if (index === 3 && this.moreContent) {
            this.moreContent()
          } else {
            this.defaultPlaceholder(item.title)
          }
        }.tabBar(this.tabItem(index, item.title, this.currTabImage[index], this.currTabImage[4]))
      })
    }.scrollable(false).barPosition(BarPosition.End)
    .onChange((index: number) => {
      this.curTabIndex = index
    })
  }
}