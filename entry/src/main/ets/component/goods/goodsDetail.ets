import { getGoodsDetail } from '../../api/goods';
import {
  GoodsDetailData,
  SpecificationGroup,
  SpecificationValue,
  Attribute,
  Issue,
  CommentItem
} from '../../viewModel/goods/goodsDetail';

// @Entry
@Component
export struct goodsDetail {
  // 接收父页面传入的完整商品详情数据
  @State detail: GoodsDetailData= {} as GoodsDetailData;
  // 本地状态
  @State quantity: number = 1;
  @State hasCollect: 0 | 1 = 0;
  @BuilderParam onBuy: (productId: number, quantity: number) => void = this.defaultOnBuy;
  @BuilderParam onAddToCart: (productId: number, quantity: number) => void = this.defaultOnAddToCart;
  @BuilderParam onCollectToggle: (hasCollect: 0 | 1) => void = this.defaultOnCollectToggle;
  @BuilderParam onShare: () => void = this.defaultOnShare;

  @Builder
  defaultOnBuy(goodsId: number, quantity: number): void {
  }

  @Builder
  defaultOnAddToCart(goodsId: number, quantity: number): void {
  }

  @Builder
  defaultOnCollectToggle(): void {
  }

  @Builder
  defaultOnShare(): void {
  }


  async aboutToAppear(): Promise<void> {
    this.hasCollect = this.detail?.userHasCollect ?? 0;
    console.log((JSON.stringify(this.detail)))
  }

  build() {
    Column(){
      if (!this.detail || !this.detail.info) {
        Column() {
          Text('夹杂中.;.;.;.;.;')
        }
      }else {
        Column() {
          Scroll() {
            Column({ space: 20 }) {

              // 1. 商品轮播图
              Swiper() {
                ForEach(this.detail.info.gallery ?? [], (url: string, index: number) => {
                  Image(url)
                    .width('100%')
                    .height(100)
                    .aspectRatio(1)
                    .objectFit(ImageFit.Cover)
                    .borderRadius(12)
                });
              }
              .height(400)
              .loop(true)
              .indicator(true)

              // 2. 商品标题和简介
              Text(this.detail.info.name)
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .width('100%')

              Text(this.detail.info.brief)
                .fontSize(16)
                .fontColor($r('sys.color.ohos_id_color_secondary'))
                .width('100%')

              // 3. 价格（暂时显示零售价）
              Text(`￥${this.detail.info.retailPrice.toFixed(2)}`)
                .fontSize(28)
                .fontColor(Color.Red)
                .fontWeight(FontWeight.Medium)
                .width('100%')

              // 4. 规格选择（静态展示）
              ForEach(this.detail.specificationList, (group: SpecificationGroup, groupIndex: number) => {
                Column({ space: 12 }) {
                  Text(group.name)
                    .fontSize(18)
                    .fontWeight(FontWeight.Medium)
                    .width('100%')

                  Row({ space: 12 }) {
                    ForEach(group.valueList, (item: SpecificationValue) => {
                      Column({ space: 4 }) {
                        if (item.picUrl && item.picUrl.length > 0) {
                          Image(item.picUrl)
                            .width(60)
                            .height(60)
                            .objectFit(ImageFit.Cover)
                            .borderRadius(8)
                        }
                        Text(item.value)
                          .fontSize(14)
                      }
                      .alignItems(HorizontalAlign.Center)
                      .padding(10)
                      .borderRadius(12)
                      .backgroundColor(Color.White)
                    });
                  }
                  .width('100%')
                }
              })

              // 5. 数量选择
              Row({ space: 16 }) {
                Text('数量').fontSize(16)
                Button('-')
                  .width(40)
                  .height(40)
                  .onClick(() => {
                    if (this.quantity > 1) this.quantity--
                  })
                Text(this.quantity.toString())
                  .fontSize(18)
                  .width(40)
                  .textAlign(TextAlign.Center)
                Button('+')
                  .width(40)
                  .height(40)
                  .onClick(() => {
                    this.quantity++
                  })
              }
              .alignItems(VerticalAlign.Center)

              // 6. 商品参数
              Text('商品参数')
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .width('100%')

              ForEach(this.detail.attribute, (attr: Attribute) => {
                Row({ space: 20 }) {
                  Text(attr.attribute)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .width(120)
                  Text(attr.value)
                    .fontSize(16)
                    .fontColor($r('sys.color.ohos_id_color_secondary'))
                }
                .width('100%')
              })

              // 7. 品牌信息
              if (this.detail.brand) {
                Row({ space: 16 }) {
                  Image(this.detail.brand.picUrl)
                    .width(60)
                    .height(60)
                    .objectFit(ImageFit.Cover)
                    .borderRadius(8)

                  Column({ space: 4 }) {
                    Text(this.detail.brand.name)
                      .fontSize(16)
                      .fontWeight(FontWeight.Medium)
                    Text(this.detail.brand.desc)
                      .fontSize(14)
                      .fontColor($r('sys.color.ohos_id_color_secondary'))
                  }
                }
                .width('100%')
                .padding(16)
                .backgroundColor($r('sys.color.ohos_id_color_background'))
              }

              // 8. 常见问题
              Text('常见问题')
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .width('100%')

              ForEach(this.detail.issue, (issue: Issue) => {
                Column({ space: 8 }) {
                  Text(issue.question)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                  Text(issue.answer)
                    .fontSize(14)
                    .fontColor($r('sys.color.ohos_id_color_secondary'))
                }
                .padding(16)
                .borderRadius(12)
                .backgroundColor($r('sys.color.ohos_id_color_background'))
                .width('100%')
              })

              // 9. 用户评价
              Row() {
                Text(`用户评价 (${this.detail.comment.count})`)
                  .fontSize(18)
                  .fontWeight(FontWeight.Medium)
                Text('查看全部 >')
                  .fontSize(14)
                  .fontColor($r('sys.color.ohos_id_color_primary'))
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .width('100%')

              ForEach(this.detail.comment.data.slice(0, 3), (comment: CommentItem) => {
                Column({ space: 12 }) {
                  Row({ space: 12 }) {
                    Image(comment.avatar.length > 0 ? comment.avatar : 'https://via.placeholder.com/40')
                      .width(40)
                      .height(40)
                      .borderRadius(20)
                    Column() {
                      Text(comment.nickname).fontSize(14)
                      Text(comment.addTime.substring(0, 10)).fontSize(12).fontColor(Color.Gray)
                    }
                  }

                  Text(comment.content).fontSize(15).lineHeight(22)

                  if (comment.picList.length > 0) {
                    Row({ space: 8 }) {
                      ForEach(comment.picList, (pic: string) => {
                        Image(pic)
                          .width(80)
                          .height(80)
                          .objectFit(ImageFit.Cover)
                          .borderRadius(8)
                      })
                    }
                  }
                }
                .padding(16)
                .borderRadius(12)
                .backgroundColor($r('sys.color.ohos_id_color_background'))
                .width('100%')
              })

            }
            .padding({ left: 16, right: 16, bottom: 100 })
          }

          // ==================== 底部操作栏（占位，你后面会单独抽组件） ====================

          Row(){
            Text('这是底部操作栏').width('100%').height(40).backgroundColor(Color.Blue)
          }.zIndex(999)
          //固定在底部
          .alignItems(VerticalAlign.Bottom)
        }
        .width('100%')
        .height('100%')
      }
    }
  }
}