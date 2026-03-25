@Component
export struct goodsTabBar {
  @State isColection:boolean = false


  build() {
    Column() {
      Row({ space: 12 }) {
        // 左侧文字按钮（淘宝风格）
        Row({space:2}){
          Text('客服')
            .fontSize(12)
            .fontColor('#666666')
          Image($r('app.media.servicer')).width(16)
        }.onClick(() => { /* 客服逻辑 */

        })

        Row({space:2}){
          Text('收藏')
            .fontSize(12)
            .fontColor('#666666')
          Image(this.isColection ? $r('app.media.colection1') : $r('app.media.colection2'))
            .width(14)
            .padding({bottom:2})
        }.onClick(() => {
          AlertDialog.show({
            message: this.isColection ? "取消收藏": "已收藏"
          })
          this.isColection = !this.isColection
        })

        Row() {
          // 购物车按钮（浅色/白色）
          Button('加入购物车')
            .width(110)
            .height(38)
            .fontSize(15)
            .fontColor('#333333')
            .backgroundColor('#F5F5F5')
            .borderRadius({
              topLeft: 24,
              bottomLeft: 24,
              topRight: 0,
              bottomRight: 0
            })
            .onClick(() => { /* 加入购物车逻辑 */
            })

          // 购买按钮（橙色渐变，淘宝经典色）
          Button('购买')
            .width(130)
            .height(38)
            .fontSize(15)
            .fontColor(Color.White)
            .backgroundColor(Color.Transparent)  // 必须先设透明
            .linearGradient({
              angle: 90,
              colors: [
                ['#FF6A00', 0.0], // 亮橙
                ['#FF3D00', 1.0]// 深橙
              ]
            })
            .borderRadius({
              topLeft: 0,
              bottomLeft: 0,
              topRight: 24,
              bottomRight: 24
            })
            .onClick(() => {
            })
        }
      }
      .backgroundColor('#ffd7d7d5')
      .width('100%')
      .height(50)
      .margin(5)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .padding(10)
      .shadow({ radius: 4, color: '#0A000000', offsetY: -2 }) // 轻微上浮阴影
    }
    .width('100%')
    .align(Alignment.Bottom)
  }
}