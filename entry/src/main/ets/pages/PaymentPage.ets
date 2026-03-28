import { getOrderDetail } from '../api/mine/order'
import { OrderInfo, OrderGoodsItem, OrderDetail } from '../viewModel/mine/order'
import { router } from '@kit.ArkUI'
import { ApiResponse } from '../viewModel'

@Entry
@Component
export struct PaymentPage {
  @State orderDetail: OrderDetail | null = null
  @State loading: boolean = true
  @State orderInfo: OrderInfo | null = null
  @State orderGoods: OrderGoodsItem[] = []
  private router = this.getUIContext().getRouter()
  private prompt = this.getUIContext().getPromptAction()

  aboutToAppear(): void {
    const params = this.router.getParams() as Record<string, Object>
    const orderId = params?.orderId as number
    if (orderId) {
      this.loadOrderDetail(orderId)
    }
  }

  private async loadOrderDetail(orderId: number): Promise<void> {
    this.loading = true
    try {
      const res: ApiResponse<OrderDetail> = await getOrderDetail(orderId)
      console.log('订单详情:', JSON.stringify(res))
      if (res.errno === 0 && res.data) {
        this.orderDetail = res.data
        this.orderInfo = res.data.orderInfo
        this.orderGoods = res.data.orderGoods
      } else {
        this.prompt.showToast({ message: res.errmsg || '获取订单详情失败' })
      }
    } catch (error) {
      console.error('获取订单详情失败', error)
      this.prompt.showToast({ message: '获取订单详情失败' })
    } finally {
      this.loading = false
    }
  }

  // 格式化价格
  private formatPrice(price: number): string {
    return price.toFixed(2)
  }

  // 获取订单状态文本
  private getOrderStatusText(status: string): string {
    return status || '未知状态'
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.right_arrow'))
          .width(24)
          .height(24)
          .onClick(() => this.router.back())
        Text('收银台')
          .fontSize(18)
          .fontColor('#333333')
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)

      if (this.loading) {
        Column() {
          LoadingProgress()
            .width(48)
            .height(48)
            .color('#ff6bbfff')
            .margin({ top: 100 })
          Text('加载中...')
            .fontSize(16)
            .fontColor('#999999')
        }
      } else if (this.orderDetail && this.orderInfo) {
        Scroll() {
          Column() {
            // 订单信息卡片
            Column() {
              Row() {
                Text('订单编号')
                  .fontSize(14)
                  .fontColor('#999999')
                Text('待支付')
                  .fontSize(14)
                  .fontColor('#ff6bbfff')
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)

              Text(this.orderInfo.orderSn || '')
                .fontSize(14)
                .fontColor('#333333')
                .margin({ top: 8 })
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .padding(16)
            .backgroundColor(Color.White)
            .borderRadius(12)
            .margin({ top: 12 })

            // 商品列表
            Column() {
              ForEach(this.orderGoods, (item: OrderGoodsItem) => {
                Row({ space: 12 }) {
                  Image(item.picUrl || '')
                    .width(80)
                    .height(80)
                    .borderRadius(8)
                  Column({ space: 4 }) {
                    Text(item.goodsName)
                      .fontSize(14)
                      .fontColor('#333333')
                      .maxLines(2)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                    Text(item.specifications?.join(' ') || '标准')
                      .fontSize(12)
                      .fontColor('#999999')
                    Row() {
                      Text(`¥${this.formatPrice(item.price)}`)
                        .fontSize(16)
                        .fontColor('#ff6bbfff')
                      Text(`x${item.number}`)
                        .fontSize(14)
                        .fontColor('#999999')
                        .layoutWeight(1)
                        .textAlign(TextAlign.End)
                    }
                  }
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start)
                }
                .padding(12)
                .backgroundColor('#f5f5f5')
                .borderRadius(8)
                .margin({ bottom: 8 })
              })
            }
            .width('100%')
            .padding(16)
            .backgroundColor(Color.White)
            .borderRadius(12)

            // 金额明细
            Column({ space: 12 }) {
              Row() {
                Text('商品金额')
                  .fontSize(14)
                  .fontColor('#333333')
                Text(`¥${this.formatPrice(this.orderInfo.goodsPrice)}`)
                  .fontSize(14)
                  .fontColor('#333333')
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)

              Row() {
                Text('运费')
                  .fontSize(14)
                  .fontColor('#333333')
                Text(`¥${this.formatPrice(this.orderInfo.freightPrice)}`)
                  .fontSize(14)
                  .fontColor('#333333')
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)

              Row() {
                Text('优惠券')
                  .fontSize(14)
                  .fontColor('#333333')
                Text(`-¥${this.formatPrice(this.orderInfo.couponPrice)}`)
                  .fontSize(14)
                  .fontColor('#ff6bbfff')
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)

              Divider()
                .color('#f0f0f0')
                .strokeWidth(0.5)

              Row() {
                Text('合计金额')
                  .fontSize(14)
                  .fontColor('#333333')
                Text(`¥${this.formatPrice(this.orderInfo.actualPrice)}`)
                  .fontSize(14)
                  .fontColor('#333333')
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
            }
            .width('100%')
            .padding(16)
            .backgroundColor(Color.White)
            .borderRadius(12)
            .margin({ top: 12 })

            // 支付方式
            Column() {
              Text('支付方式')
                .fontSize(14)
                .fontColor('#333333')
                .textAlign(TextAlign.Start)
              Row() {
                Row() {
                  Image($r('app.media.startIcon'))
                    .width(24)
                    .height(24)
                  Text('微信支付')
                    .fontSize(14)
                    .fontColor('#333333')
                  Text(`¥${this.formatPrice(this.orderInfo.actualPrice)}`)
                    .fontSize(14)
                    .fontColor('#333333')
                }
                .layoutWeight(1)
                .justifyContent(FlexAlign.SpaceBetween)
              }
              .width('100%')
              .alignItems(VerticalAlign.Center)
              .padding(12)
              .backgroundColor(Color.White)
              .borderRadius(8)
              .margin({ top: 8 })
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .padding(16)
            .backgroundColor(Color.White)
            .borderRadius(12)
          }
          .padding(12)
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)
      }

      if (this.orderInfo) {
        // 底部支付按钮
        Column() {
          Row() {
            Text(`合计金额：`)
              .fontSize(14)
              .fontColor('#333333')
            Text(`¥${this.formatPrice(this.orderInfo.actualPrice)}`)
              .fontSize(18)
              .fontColor('#ff6bbfff')
              .fontWeight(FontWeight.Medium)
          }
          .width('100%')
          .justifyContent(FlexAlign.End)
          .alignItems(VerticalAlign.Center)
          .padding({ left: 16, right: 16 })

          Button('确认支付')
            .fontSize(16)
            .fontColor(Color.White)
            .backgroundColor('#ff6bbfff')
            .width('100%')
            .height(48)
            .borderRadius(0)
            .onClick(() => {
              this.prompt.showToast({ message: '支付功能开发中' })
            })
        }
        .padding({ bottom: 20, left: 16, right: 16 })
        .backgroundColor(Color.White)
        .border({ width: { top: 0.5 }, color: '#f0f0f0' })
      }
    }
    .justifyContent(FlexAlign.Start)
    .padding({ top: 30 })
    .padding({top:30})
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}
