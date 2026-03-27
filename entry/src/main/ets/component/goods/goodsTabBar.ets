import { Prompt } from "@kit.ArkUI";

@Component
export struct goodsTabBar {
  // 收藏状态
  @State isCollected: boolean = false;
  // 回调事件（由父页面处理）
  onAddToCart?: () => void;
  onBuyNow?: () => void;
  onCustomerService?: () => void;

  build() {
    Column() {
      Row({ space: 12 }) {
        // 客服
        Row({ space: 4 }) {
          Text('客服')
            .fontSize(13)
            .fontColor('#666666')
          Image($r('app.media.servicer'))
            .width(18)
            .height(18)
        }
        .onClick(() => this.onCustomerService?.())

        // 收藏
        Row({ space: 4 }) {
          Text('收藏')
            .fontSize(13)
            .fontColor('#666666')
          Image(this.isCollected ? $r('app.media.colection1') : $r('app.media.colection2'))
            .width(16)
            .height(16)
        }
        .onClick(() => {
          this.isCollected = !this.isCollected;
          Prompt.showToast({
            message: this.isCollected ? '已收藏' : '已取消收藏'
          });
        })

        // 操作按钮区域
        Row({ space: 0 }) {
          Button('加入购物车')
            .width(120)
            .height(42)
            .fontSize(15)
            .fontColor('#333333')
            .backgroundColor('#F5F5F5')
            .borderRadius({
              topLeft: 24,
              bottomLeft: 24,
              topRight: 0,
              bottomRight: 0
            })
            .onClick(() => this.onAddToCart?.())

          Button('立即购买')
            .width(130)
            .height(42)
            .fontSize(15)
            .fontColor(Color.White)
            .linearGradient({
              angle: 90,
              colors: [['#FF6A00', 0.0], ['#FF3D00', 1.0]]
            })
            .borderRadius({
              topLeft: 0,
              bottomLeft: 0,
              topRight: 24,
              bottomRight: 24
            })
            .onClick(() => this.onBuyNow?.())
        }
      }
      .width('100%')
      .height(56)
      .padding({ left: 12, right: 12 })
      .backgroundColor('#ffffff')
      .shadow({ radius: 6, color: '#0A000000', offsetY: -2 })
      .alignItems(VerticalAlign.Center)
    }
    .padding({bottom:30})
    .width('100%')
    .align(Alignment.Bottom)
  }
}