// goods.ets
@Component
export struct goods {

  // ==================== 参数（支持外部传入） ====================
  @Prop goodTitle: string = "商品标题"
  @Prop goodsImage: string = '../../assets/image/zzz.png'
  @Prop goodsDesc: string = "商品描述"
  @Prop goodsCurPrice?: string | number |null= null
  @Prop goodsRealPrice?: string | number |null = null

  build() {
    Row({ space:8 }) { // 整体横向布局 + 间距
      // 左侧图片
      Image(this.goodsImage)
        .width(68)
        .height(68)
        .objectFit(ImageFit.Contain)
        .borderRadius(8)

      // 右侧信息区
      Column({ space: 6 }) {
        Text(this.goodTitle)
          .width('100%')
          .textAlign(TextAlign.Start)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(this.goodsDesc)
          .width('100%')
          .textAlign(TextAlign.Start)
          .fontSize(10)
          .fontColor(Color.Gray)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        // 价格行
        if (this.goodsRealPrice && this.goodsCurPrice){
          Row({ space: 8 }) {
            Text(`￥${this.goodsRealPrice}`)
              .textAlign(TextAlign.Start)
              .fontSize(14)
              .fontColor(Color.Red)
              .fontWeight(FontWeight.Bold)

            Text(`￥${this.goodsCurPrice}`)
              .textAlign(TextAlign.Start)
              .fontSize(10)
              .fontColor(Color.Gray)
              .decoration({ type: TextDecorationType.LineThrough })
          }
          .width('100%')
          .alignItems(VerticalAlign.Bottom)
        }
      }
      .layoutWeight(1) // 占满剩余空间
      .justifyContent(FlexAlign.Start)
    }
    .shadow({
      offsetY: 3,
      offsetX: 2,
      radius: 10,
      color: Color.Gray,
      fill: false
    })
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Top)
    .padding(5) // 整体内边距
    .border({ width: 1, color: Color.Gray, radius: 12 })
    .backgroundColor(Color.White)
    .margin({ bottom: 5 }) // 多个商品之间留间距
  }
}