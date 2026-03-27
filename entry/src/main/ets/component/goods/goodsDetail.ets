import { Brand, CommentItem, GoodsDetailData } from '../../viewModel/goods/goodsDetail';
import { header } from '../common/header';
import { goodsTabBar } from './goodsTabBar';
import { AttributeDialog } from './AttributeDialog';
import { AddToCartDialog } from './AddToCartDialog'; // 新增
import { Prompt } from '@kit.ArkUI';
import { addToCart } from '../../api/cart/cart';

@Component
export struct goodsDetail {
  @State detail: GoodsDetailData = {} as GoodsDetailData;
  @State quantity: number = 1;
  @State hasCollect: 0 | 1 = 0;
  @State detailImageUrls: string[] = [];
  // 弹窗控制器
  private attrDialogController: CustomDialogController | null = null;
  private addToCartDialogController: CustomDialogController | null = null;
  private goodsRouter = this.getUIContext().getRouter();
  private prompt = this.getUIContext().getPromptAction();

  private parseDetailImages(): void {
    if (!this.detail?.info?.detail) {
      this.detailImageUrls = [];
      return;
    }
    const html: string = this.detail.info.detail;
    const urls: string[] = [];
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

  async aboutToAppear(): Promise<void> {
    this.hasCollect = this.detail?.userHasCollect ?? 0;
    this.parseDetailImages();

    // 原有属性弹窗
    this.attrDialogController = new CustomDialogController({
      builder: AttributeDialog({ attributes: this.detail.attribute || [] }),
      customStyle: true,
      alignment: DialogAlignment.Bottom,
    });

    // 新增：加入购物车规格选择弹窗
    this.addToCartDialogController = new CustomDialogController({
      builder: AddToCartDialog({
        specificationList: this.detail.specificationList || [],
        productList: this.detail.productList || [],
        goodsId: this.detail.info?.id || 0,
        defaultPrice: this.detail.info?.retailPrice || 0,
        onAddToCart: (productId: number, quantity: number) => this.handleAddToCart(productId, quantity),
        onFastBuy: (productId: number, quantity: number) => this.handleFastBuy(productId, quantity)
      }),
      customStyle: true,
      alignment: DialogAlignment.Bottom,
    });
  }

  // 加入购物车逻辑
  private async handleAddToCart(productId: number, quantity: number): Promise<void> {
    if (!this.detail.info?.id) return;

    try {
      const res = await addToCart({
        goodsId: this.detail.info.id,
        productId: productId,
        number: quantity
      });
      console.log(JSON.stringify('加入购物车的返回数据:'+res))

      if (res.errno === 0) {
        this.prompt.showToast({ message: '已成功加入购物车', duration: 2000 });
      } else {
        this.prompt.showToast({ message: res.errmsg || '加入购物车失败' });
      }
    } catch (error) {
      console.error('加入购物车失败:', error);
      this.prompt.showToast({ message: '网络错误，请重试' });
    }
  }

  // 立即购买逻辑
  private handleFastBuy(productId: number, quantity: number): void {
    // this.prompt.showToast({ message: '立即购买功能开发中...' });
    // 后续可跳转到结算页：
    this.goodsRouter.pushUrl({ url: '/view/mine/CheckoutPage' ,params:{
      productId: productId,
    }});
  }

  // 打开加入购物车弹窗
  private openAddToCartDialog(): void {
    this.addToCartDialogController?.open();
  }

  build() {
    Column() {
      Blank().height(30)

      if (!this.detail || !this.detail.info) {
        Column() {
          Text('加载中...')
            .fontSize(16)
            .fontColor(Color.Black)
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      } else {

        Stack() {
          // 顶部返回栏
          Row() {
            Row() {
              Image($r('app.media.right_arrow'))
                .width(20)
                .fillColor(Color.Black)
                .padding({ left: 5, bottom: 2 })

              Text('返回')
                .textAlign(TextAlign.End)
                .height(30)
                .padding(5)
                .onClick(() => this.goodsRouter.back())
            }.width('20%')

            Text().width('80%').height(30).backgroundColor(Color.White)
          }
          .justifyContent(FlexAlign.Center)
          .position({ top: 0 })
          .zIndex(999)

          // ==================== 可滚动主内容 ====================
          Scroll() {
            Column({ space: 10 }) {
              // Swiper 轮播图
              Swiper() {
                ForEach(this.detail.info.gallery ?? [], (url: string) => {
                  Image(url)
                    .width('100%')
                    .height('100%')
                    .objectFit(ImageFit.Cover)
                });
              }
              .height(220)
              .loop(true)
              .indicator(true)
              .indicatorStyle({ selectedColor: Color.Blue })
              .borderRadius(0)

              // 价格区
              Row() {
                Text(`￥${this.detail.info.retailPrice.toFixed(2)}`)
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.Black)

                Text(`￥${this.detail.info.counterPrice.toFixed(2)}`)
                  .fontSize(10)
                  .fontColor(Color.Gray)
                  .decoration({ type: TextDecorationType.LineThrough })
              }
              .alignItems(VerticalAlign.Center)
              .width('100%')
              .padding({ left: 10 })

              // 商品标题
              Text(this.detail.info.name)
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .width('100%')
                .padding({ left: 10 })

              // 商品简介
              Text(this.detail.info.brief)
                .fontSize(15)
                .fontColor(Color.Gray)
                .width('100%')
                .padding({ left: 16, right: 16 })

              // 规格入口
              Row() {
                header({ head: '规格', moreHead: '请选择' })
              }
              .width('100%')
              .padding({ left: 20, top: 5, right: 10 })
              .justifyContent(FlexAlign.SpaceBetween)
              .onClick(() => this.openAddToCartDialog())

              Divider().width('90%').strokeWidth(1)

              // 属性
              Column({ space: 10 }) {
                Row() {
                  header({ head: '属性', moreHead: ' ' })
                }
                .width('100%')
                .padding({ left: 20, top: 5, right: 10 })
                .justifyContent(FlexAlign.SpaceBetween)
                .onClick(() => this.attrDialogController?.open())

                Divider().width('90%').strokeWidth(1)

                // 品牌信息
                if (this.detail.brand && this.detail.brand.name) {
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
                  .border({ width: 1, color: Color.Gray })
                  .width('80%')
                  .padding(10)
                  .borderRadius(12)
                  .onClick(() => {
                    this.goodsRouter.pushUrl({
                      url: 'view/home/BrandDetailPage',
                      params: { id: this.detail.brand.id } as Brand
                    })
                  })
                } else {
                  Divider().width('90%').strokeWidth(1)
                }

                // 运费
                Row() {
                  Text('运费').fontSize(14).fontColor(Color.Black)
                  Text('满88免邮费').fontSize(12).fontColor(Color.Gray)
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .padding({ top: 10, left: 20, right: 10 })
                .width('100%')

                Divider().width('90%').strokeWidth(1)
              }
              .width('100%')
              .margin({ top: 8 })

              // 商品参数
              Row() {
                header({ moreHead: '检查', head: '商品参数' })
              }
              .padding({ left: 20, right: 10 })

              Divider().width('90%').strokeWidth(1)

              // 常见问题
              Row() {
                Button() {
                  header({ head: '常见问题', moreHead: '详细查看:' })
                }
                .backgroundColor(Color.White)
                .bindMenu([
                  { value: '选项1', action: () => console.log('选中1') },
                  { value: '选项2', action: () => console.log('选中2') }
                ])
                .width('100%')
              }
              .padding({ left: 20, right: 10 })

              Divider().width('90%').strokeWidth(1)

              // 用户评价
              Row() {
                header({ head: '评论', moreHead: '更多评论' })
              }
              .padding({ left: 20, right: 10 })
              .justifyContent(FlexAlign.SpaceBetween)
              .width('100%')

              Divider().width('90%').strokeWidth(1)

              // 评论列表
              ForEach(this.detail.comment.data.slice(0, 3), (comment: CommentItem) => {
                Column() {
                  Row({ space: 10 }) {
                    Row({ space: 8 }) {
                      Image(comment.avatar).width(20).height(20).borderRadius(10)
                      Column() {
                        Text(comment.nickname).fontSize(12).fontWeight(FontWeight.Medium)
                        Text(comment.addTime.substring(0, 10)).fontSize(10).fontColor('#999')
                      }
                    }
                    .layoutWeight(3)

                    Column() {
                      Text(comment.content)
                        .fontSize(15)
                        .maxLines(3)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })

                      if (comment.picList?.length > 0) {
                        Row() {
                          ForEach(comment.picList.slice(0, 3), (pic: string) => {
                            Image(pic).width(80).height(80).objectFit(ImageFit.Cover).borderRadius(8)
                          })
                        }
                      }
                    }
                    .layoutWeight(7)
                  }
                  .width('100%')
                  .backgroundColor('#F8F8F8')
                  .borderRadius(12)
                }
                .margin({ bottom: 12 })
              })

              // 商品详情图片
              Text('商品详情')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .width('100%')
                .textAlign(TextAlign.Center)
                .padding({ top: 20, bottom: 20 })

              Column() {
                ForEach(this.detailImageUrls, (url: string) => {
                  Image(url)
                    .width('100%')
                    .objectFit(ImageFit.Contain)
                })
              }
            }
          }

          // ==================== 底部操作栏 ====================
          goodsTabBar({
            onAddToCart: () => this.openAddToCartDialog(),
            onBuyNow: () => this.openAddToCartDialog()
          })
            .position({ bottom: 0 })
            .zIndex(999)
        }
        .width('100%')
        .height('100%')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}