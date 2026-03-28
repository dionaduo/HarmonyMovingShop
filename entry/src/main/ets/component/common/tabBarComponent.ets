import { TabContentBuilder, window } from "@kit.ArkUI";

interface ITitle {
  title: string;
  color: Color;
}

@Component
export struct tabBarComponent {
  @Link curTabIndex: number
  @State currTabImage: Resource[] = [
    $r('app.media.home'),
    $r('app.media.category'),
    $r('app.media.cart'),
    $r('app.media.mine'),
    $r('app.media.dog')
  ]
  @State titleList: ITitle[] = [
    { title: '首页', color: Color.Red },
    { title: '分类', color: Color.Blue },
    { title: '购物车', color: Color.Green },
    { title: '我的', color: Color.Orange }
  ]

  // 路由守卫回调 - 返回 true 允许切换，false 阻止切换
  onTabChange?: (index: number) => Promise<boolean>;

  aboutToAppear(): void {
    console.log('tabBarComponent aboutToAppear, curTabIndex:', this.curTabIndex)
  }

  @Builder
  tabItem(index: number, title: string, icon: Resource, selectedIcon: Resource) {
    Column() {
      Image(index == this.curTabIndex ? selectedIcon : icon).width(16)
      Divider()
        .width(35)
        .strokeWidth(3)
        .margin({ top: 3, bottom: 3 })
        .backgroundColor(index == this.curTabIndex ? Color.Red : Color.Transparent)
      Text(title).fontSize(14).fontColor(index == this.curTabIndex ? Color.Red : Color.Black).padding({ bottom: 30 })
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
    Column() {
      // Tab 内容区域 - 用 Column 包装，可以添加 layoutWeight
      Column() {
        if (this.curTabIndex === 0 && this.homeContent) {
          this.homeContent()
        } else if (this.curTabIndex === 1 && this.recommendContent) {
          this.recommendContent()
        } else if (this.curTabIndex === 2 && this.favoriteContent) {
          this.favoriteContent()
        } else if (this.curTabIndex === 3 && this.moreContent) {
          this.moreContent()
        } else {
          this.defaultPlaceholder(this.titleList[this.curTabIndex].title)
        }
      }
      .layoutWeight(1)

      // 自定义 TabBar
      Row() {
        ForEach(this.titleList, (item: ITitle, index: number) => {
          Column() {
            this.tabItem(index, item.title, this.currTabImage[index], this.currTabImage[4])
          }
          .layoutWeight(1)
          .onClick(async () => {
            console.log('Tab clicked, index:', index, 'current:', this.curTabIndex)
            console.log('onTabChange exists:', !!this.onTabChange)
            if (index === this.curTabIndex) return

            // 如果有守卫回调，先执行守卫逻辑
            if (this.onTabChange) {
              console.log('Calling onTabChange...')
              try {
                const canChange = await this.onTabChange(index)
                console.log('canChange:', canChange)
                if (canChange) {
                  this.curTabIndex = index
                }
              } catch (error) {
                console.error('Error in onTabChange:', error)
              }
            } else {
              console.log('No onTabChange callback, switching directly')
              this.curTabIndex = index
            }
          })
        })
      }
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)
      .border({ width: { top: 0.5 }, color: '#F0F0F0' })
    }
    .width('100%')
    .height('100%')
  }
}
