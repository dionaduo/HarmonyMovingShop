import { OrderGoodsItem as OrderGoodsItemType } from '../../viewModel/mine/order'

interface GeneratedTypeLiteralInterface_1 {
  cancel: boolean;
  delete: boolean;
  pay: boolean;
  comment: boolean;
  confirm: boolean;
  refund: boolean;
  rebuy: boolean;
  aftersale: boolean;
}

@Component
export struct OrderGoodsItem {
  @Prop orderSn: string
  @Prop picUrl: string
  @Prop goodsName: string
  @Prop actualPrice: number
  @Prop specifications: string[]
  @Prop number: number
  @Prop orderStatusText: string
  @Prop handleOption: GeneratedTypeLiteralInterface_1

  build() {
    Column() {
      Row() {
        Text('订单编号: ' + this.orderSn)
          .fontSize(14)
          .fontColor('#999999')
        Text(this.orderStatusText)
          .fontSize(14)
          .fontColor('#FF0000')
      }.width('100%').justifyContent(FlexAlign.SpaceBetween).padding({ left: 15, right: 15, top: 15 })
      Row() {
        Image(this.picUrl)
          .width(80)
          .height(80)
          .borderRadius(8)
          .objectFit(ImageFit.Cover)
          .margin({ right: 12 })
        Column() {
          Text(this.goodsName)
            .fontSize(16)
            .fontColor('#333333')
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 6 })
          if (this.specifications.length > 0) {
            Text(this.specifications.join(' '))
              .fontSize(13)
              .fontColor('#999999')
              .margin({ bottom: 6 })
          }
        }
        .alignItems(HorizontalAlign.Start)
        Column() {
          Text('x' + this.number)
            .fontSize(14)
            .fontColor('#999999')
        }
        .alignItems(HorizontalAlign.End)
      }.width('100%').padding({ left: 15, right: 15, top: 12 })
      Row() {
        Text('合计: ')
          .fontSize(16)
          .fontColor('#333333')
        Text('¥' + this.actualPrice.toFixed(2))
          .fontSize(16)
          .fontColor('#333333')
          .fontWeight(FontWeight.Medium)
        Text('(含运费)')
          .fontSize(12)
          .fontColor('#999999')
          .margin({ left: 4 })
      }.width('100%').justifyContent(FlexAlign.End).padding({ left: 15, right: 15, top: 12 })
      Row() {
        if (this.handleOption.delete) {
          Text('删除订单')
            .fontSize(14)
            .fontColor('#333333')
            .border({ width: 1, color: '#CCCCCC' })
            .borderRadius(16)
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .margin({ left: 12 })
        }
      }.width('100%').justifyContent(FlexAlign.End).padding({ left: 15, right: 15, top: 12, bottom: 15 })
    }.width('100%').backgroundColor(Color.White)
  }
}
