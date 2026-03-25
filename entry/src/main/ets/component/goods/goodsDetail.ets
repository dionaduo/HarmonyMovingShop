import {
  GoodsDetailData,
  SpecificationGroup,
  SpecificationValue,
  Attribute,
  Issue,
  CommentItem
} from '../../viewModel/goods/goodsDetail';
import { header } from '../common/header';
import { window } from '@kit.ArkUI';
import { goodsTabBar } from './goodsTabBar';
import { AttributeDialog } from './AttributeDialog';

@Component
export struct goodsDetail {

  @State detail: GoodsDetailData = {} as GoodsDetailData;
  // 本地状态
  @State quantity: number = 1;
  @State hasCollect: 0 | 1 = 0;
  @State detailImageUrls: string[] = [];
  //自定义弹窗
  private attrDialogController: CustomDialogController | null = null

  private parseDetailImages(): void {
    if (!this.detail?.info?.detail) {
      this.detailImageUrls = [];
      return;
    }
    const html: string = this.detail.info.detail;
    const urls: string[] = [];
    // 使用正则表达式匹配 img 标签中的 src 属性
    // 支持单引号、双引号或无引号的情况
    const imgRegex = /<img[^>]+src=["']?([^"'\s>]+)["']?[^>]*>/gi;
    let match: RegExpExecArray | null;

    while ((match = imgRegex.exec(html)) !== null) {
      let url = match[1].trim();
      if (url.startsWith('http://') || url.startsWith('https://')) {
        urls.push(url);
      }
    }

    this.detailImageUrls = urls;
  }

  private goodsRouter = this.getUIContext().getRouter()

  async aboutToAppear(): Promise<void> {
    this.hasCollect = this.detail?.userHasCollect ?? 0;
    this.parseDetailImages();
    this.attrDialogController = new CustomDialogController({
      builder: AttributeDialog({ attributes: this.detail.attribute }),
      customStyle: true,
      alignment: DialogAlignment.Bottom,
    })
  }
  build() {
    Column() {
      if (!this.detail || !this.detail.info) {
        Column() {
          Text('加载中...')
            .fontSize(16)
            .fontColor($r('sys.color.ohos_id_color_secondary'))
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      } else {

        Stack() {
          Row(){
            Row(){
              Image($r('app.media.right_arrow'))
                .width(20)
                .fillColor(Color.White)
                .padding({left:5,bottom:2})
              Text('返回')
                .textAlign(TextAlign.End)
                .height(30)
                .padding(5)
                .onClick(() => {
                  console.log("点击返回按钮:" + this.goodsRouter.back())
                  this.goodsRouter.back()
                })
            }.width('20%').backgroundColor(Color.Gray)

            Text().width('80%').height(30).backgroundColor(Color.White)
          }.justifyContent(FlexAlign.Center).position({top:0}).zIndex(999)
          // ==================== 可滚动主内容 ====================
          Scroll() {
            Column({ space: 10 }) {
              Swiper() {
                ForEach(this.detail.info.gallery ?? [], (url: string) => {
                  Image(url)
                    .width('100%')
                    .height('100%')
                    .objectFit(ImageFit.Cover)
                });
              }
              .height(220) // 鸿蒙推荐高度，匹配截图床垫主图比例
              .loop(true)
              .indicator(true)
              .indicatorStyle({ selectedColor: Color.Blue })
              .borderRadius(0) // 截图中无圆角

              // 2. 价格区
              Row() {
                Text(`￥${this.detail.info.retailPrice.toFixed(2)}`)
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.Black)

                Text(`￥${this.detail.info.counterPrice.toFixed(2)}`)
                  .fontSize(10)
                  .fontColor(Color.Gray)
                  .decoration({ type: TextDecorationType.LineThrough })
              }.alignItems(VerticalAlign.Center)
              .width('100%')
              .padding({ left: 10})

              // 3. 商品标题 + 简介（严格匹配截图）
              Text(this.detail.info.name)
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .width('100%')
                .padding({left:10})

              Text(this.detail.info.brief)
                .fontSize(15)
                .fontColor(Color.Gray)
                .width('100%')
                .padding({ left: 16, right: 16 })


              Row() {
                header({
                  head: '规格',
                  moreHead: '请选择'
                })
              }
              .width('100%')
              .padding({ left: 20, top: 5, right: 10 })
              .justifyContent(FlexAlign.SpaceBetween)

              Divider().width('90%').strokeWidth(1)

              Column({space:10}) {
                Row() {
                  header({
                    head:'属性',
                    moreHead:' '
                  })
                }
                .width('100%')
                .padding({left:20,top:5,right:10})
                .justifyContent(FlexAlign.SpaceBetween)
                .onClick(() => {
                  this.attrDialogController?.open()
                  console.log('打开弹窗')
                })

                Divider().width('90%').strokeWidth(1)


                // 6. 品牌信息
                if (this.detail.brand != null && this.detail.brand.name != null) {
                  Row() {
                    Image(this.detail.brand.picUrl)
                      .width(60)
                      .height(60)
                      .borderRadius(8)

                    Column({ space: 3 }) {
                      Text(this.detail.brand.name)
                        .fontSize(16)
                        .fontWeight(FontWeight.Medium)
                        .textAlign(TextAlign.Center)
                      Text(this.detail.brand.desc)
                        .fontSize(10)
                        .fontColor(Color.Gray)
                        .width('100%')
                        .padding({ left: 10, right: 10 })
                    }.width('80%')
                  }
                  .border({
                    width: 1,
                    color: Color.Gray
                  })
                  .width('80%')
                  .padding(10)
                  .borderRadius(12)
                }else {
                  Divider().width('90%').strokeWidth(1)
                }

                // 运费（直接来自 issue 数据或固定文案，匹配截图）
                Row() {
                  Text('运费')
                    .fontSize(14)
                    .fontColor(Color.Black)
                  Text('满88免邮费')
                    .fontSize(12)
                    .fontColor(Color.Gray)
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .padding({ top: 10,left: 20, right: 10}).width('100%')

                Divider().width('90%').strokeWidth(1)

              }
              .width('100%')
              .margin({ top: 8 })

              // 5. 商品参数
              Row() {
                header({moreHead:'检查',head:'商品参数'})
                  .onClick(()=>{

                  })
              }.padding({ left: 20, right: 10 })

              Divider().width('90%').strokeWidth(1)

              // 7. 常见问题（保留）
              Row(){
                Button(){
                  header({ head: '常见问题', moreHead: '详细查看:' })
                }
                .backgroundColor(Color.White)
                .bindMenu([
                  { value: '选项1', action: () => console.log('选中1') },
                  { value: '选项2', action: () => console.log('选中2') }
                ])
                .width('100%')
              }.padding({ left: 20, right: 10 })

              Divider().width('90%').strokeWidth(1)

              // 8. 用户评价
              Row() {
                header({
                  head:'评论',
                  moreHead:'更多评论'
                })
              }.padding({left:20,right:10})
              .justifyContent(FlexAlign.SpaceBetween)
              .width('100%')

              Divider().width('90%').strokeWidth(1)

              ForEach(this.detail.comment.data.slice(0, 3), (comment: CommentItem) => {
                Column() {
                  Row({space:10}) {
                    // 左侧：用户信息
                    Row({space: 8 }) {
                      Image(comment.avatar)
                        .width(20)
                        .height(20)
                        .borderRadius(10)

                      Column() {
                        Text(comment.nickname).fontSize(12).fontWeight(FontWeight.Medium).width('100%')
                        Text(comment.addTime.substring(0, 10)).width('100%')
                          .fontSize(10)
                          .fontColor('#999')
                      }.width("100%")
                      .alignItems(HorizontalAlign.Start)
                    }
                    .alignItems(VerticalAlign.Center)
                    .layoutWeight(3)

                    // 右侧：评论内容
                    Column() {
                      Text(comment.content)
                        .fontSize(15)
                        .maxLines(3)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })

                      if (comment.picList?.length > 0) {
                        Row() {
                          ForEach(comment.picList.slice(0, 3), (pic: string) => {
                            Image(pic)
                              .width(80)
                              .height(80)
                              .objectFit(ImageFit.Cover)
                              .borderRadius(8)
                          })
                        }
                      }
                    }.layoutWeight(7)
                    .alignItems(HorizontalAlign.Start)
                  }.alignItems(VerticalAlign.Top)
                  .width('100%')
                  .borderRadius(12)
                  .backgroundColor('#F8F8F8')
                }
                .margin({ bottom: 12 })
              })

              // ==================== 商品详情部分（核心优化） ====================
              Text('商品详情')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .width('100%')
                .textAlign(TextAlign.Center)
                .padding({ top: 20,bottom:20})
              Column() {
                ForEach(this.detailImageUrls, (url: string) => {
                  Image(url)
                    .height(100)
                    .width('100%')
                    .objectRepeat(ImageRepeat.NoRepeat)

                });
              }
              .width('100%')
            }
          }
          // ==================== 固定底部操作栏 ====================
          Row() {
            // 可后续替换为真实购买按钮、收藏等
            goodsTabBar()
          }
          .height(10)
          .width('100%')
          .position({bottom:45})
          .zIndex(999)
        }
        .width('100%')
        .height('100%')
      }
    }
  }
}