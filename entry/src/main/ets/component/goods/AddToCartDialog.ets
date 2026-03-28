import { Product, SpecificationGroup } from '../../viewModel/goods/goodsDetail';
import { addCartParams, addToCart, fastAddParams, fastAddToCart } from '../../api/cart/cart';


@CustomDialog
@Component
export struct AddToCartDialog {
  private dialogController: CustomDialogController;
  @Prop specificationList: SpecificationGroup[] = [];
  @Prop productList: Product[] = [];
  @Prop goodsId: number = 0;
  @Prop defaultPrice: number = 0;
  @Prop goodsName: string = '';
  @Prop goodsPicUrl: string = '';
  // 回调函数
  onAddToCart?: (productId: number, quantity: number) => void;
  onFastBuy?: (cartId: number, quantity: number) => void;
  @State selectedProductIndex: number = 0;
  @State quantity: number = 1;
  @State isLoading: boolean = false;
  private prompt = this.getUIContext().getPromptAction()
  // 本地状态存储productList的副本
  @State localProductList: Product[] = [];

  aboutToAppear(): void {
    console.log('AddToCartDialog aboutToAppear')
    console.log('specificationList:', JSON.stringify(this.specificationList))
    console.log('productList:', JSON.stringify(this.productList))
    console.log('goodsId:', this.goodsId)
    console.log('defaultPrice:', this.defaultPrice)
    // 将productList复制到本地状态
    this.localProductList = [...this.productList];
    console.log('localProductList:', JSON.stringify(this.localProductList))
  }

  // 安全获取当前选中规格
  private getCurrentProduct(): Product {
    console.log('getCurrentProduct - localProductList:', JSON.stringify(this.localProductList))
    console.log('getCurrentProduct - localProductList.length:', this.localProductList.length, 'selectedProductIndex:', this.selectedProductIndex)
    if (this.localProductList.length === 0) {
      console.log('getCurrentProduct - localProductList为空,返回空对象')
      return {} as Product;
    }
    if (this.selectedProductIndex >= this.localProductList.length) {
      console.log('getCurrentProduct - 索引越界,重置为0')
      this.selectedProductIndex = 0;
    }
    const product = this.localProductList[this.selectedProductIndex];
    console.log('getCurrentProduct - 返回:', JSON.stringify(product))
    return product;
  }

  private getCurrentPrice(): number {
    const product = this.getCurrentProduct();
    return product?.price ?? this.defaultPrice;
  }

  private getCurrentStock(): number {
    const product = this.getCurrentProduct();
    return product?.number ?? 999;
  }

  private getCurrentSpecText(): string {
    const product = this.getCurrentProduct();
    const specs = product?.specifications || [];
    console.log('getCurrentSpecText - specs:', JSON.stringify(specs))
    if (specs.length === 0) {
      return '请选择规格';
    }
    return specs.join(' ');
  }

  private selectProduct(index: number): void {
    console.log('selectProduct - index:', index, 'localProductList.length:', this.localProductList.length)
    if (index >= 0 && index < this.localProductList.length) {
      this.selectedProductIndex = index;
      this.quantity = 1;
      console.log('选中规格:', this.localProductList[index].specifications)
    }
  }

  private changeQuantity(delta: number): void {
    let newQty = this.quantity + delta;
    if (newQty < 1) newQty = 1;
    if (newQty > this.getCurrentStock()) {
      this.prompt.showToast({ message: `库存不足，仅剩 ${this.getCurrentStock()} 件` });
      return;
    }
    this.quantity = newQty;
  }

  private async handleAddToCart(): Promise<void> {
    console.log('handleAddToCart - 开始执行')
    console.log('handleAddToCart - localProductList.length:', this.localProductList.length)
    console.log('handleAddToCart - selectedProductIndex:', this.selectedProductIndex)
    console.log('handleAddToCart - localProductList:', JSON.stringify(this.localProductList))

    const product = this.getCurrentProduct();
    console.log('handleAddToCart - product:', JSON.stringify(product))
    console.log('handleAddToCart - product.id:', product?.id)
    console.log('handleAddToCart - goodsId:', this.goodsId)
    console.log('handleAddToCart - quantity:', this.quantity)

    if (this.localProductList.length === 0) {
      console.log('handleAddToCart - localProductList为空')
      this.prompt.showToast({ message: '该商品暂无规格' });
      return;
    }

    if (!product || !product.id) {
      console.log('handleAddToCart - 产品无效，显示提示')
      this.prompt.showToast({ message: '请先选择规格' });
      return;
    }

    if (this.goodsId === 0) {
      this.prompt.showToast({ message: '商品信息错误' });
      return;
    }

    this.isLoading = true;

    try {
      const params: addCartParams = {
        goodsId: this.goodsId,
        productId: product.id,
        number: this.quantity
      };

      console.log('handleAddToCart - 请求参数:', JSON.stringify(params))
      const res = await addToCart(params);
      console.log('addToCart返回:' + JSON.stringify(res))

      if (res.errno === 0) {
        this.prompt.showToast({ message: '已加入购物车' });
        this.onAddToCart?.(product.id, this.quantity);
        this.dialogController.close();
      } else {
        this.prompt.showToast({ message: res.errmsg || '加入购物车失败' });
      }
    } catch (error) {
      console.error('加入购物车失败:', error);
      this.prompt.showToast({ message: '加入购物车失败，请重试' });
    } finally {
      this.isLoading = false;
    }
  }

  private async handleFastBuy(): Promise<void> {
    const product = this.getCurrentProduct();
    if (!product || !product.id) {
      this.prompt.showToast({ message: '请先选择规格' });
      return;
    }

    if (this.goodsId === 0) {
      this.prompt.showToast({ message: '商品信息错误' });
      return;
    }

    try {
      const params: fastAddParams = {
        goodsId: this.goodsId,
        productId: product.id,
        number: this.quantity
      };

      const res = await fastAddToCart(params);
      console.log('fastAddToCart返回:' + JSON.stringify(res))

      if (res.errno === 0 && res.data) {
        const cartId = res.data;

        if (cartId) {
          this.onFastBuy?.(cartId, this.quantity);
          this.dialogController.close();
        } else {
          this.prompt.showToast({ message: '购买失败，请重试' });
        }
      } else {
        this.prompt.showToast({ message: res.errmsg || '购买失败' });
      }
    } catch (error) {
      console.error('立即购买失败:', error);
      this.prompt.showToast({ message: '购买失败，请重试' });
    }
  }

  build() {

    Column({ space: 0 }) {
      // 标题栏
      Row() {
        Text('选择规格')
          .fontSize(16)
          .fontWeight(500)
          .fontColor('#1d1d1f')
          .lineHeight(22)

        Blank()

        Image($r('app.media.right_arrow'))
          .width(24)
          .height(24)
          .fillColor('#86868b')
          .rotate({ angle: 180 })
          .onClick(() => this.dialogController.close())
      }
      .width('100%')
      .height(48)
      .padding({ left: 20, right: 20 })

      Scroll() {
        Column({ space: 16 }) {
          // 商品信息展示区域
          Row({ space: 12 }) {
            // 商品图片
            Image(this.goodsPicUrl || this.getCurrentProduct()?.url || '')
              .width(80)
              .height(80)
              .borderRadius(8)
              .objectFit(ImageFit.Cover)
              .backgroundColor('#f5f5f7')

            Column({ space: 4 }) {
              // 商品名称
              Text(this.goodsName || '商品名称')
                .fontSize(14)
                .fontColor('#1d1d1f')
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })

              // 当前规格
              Text(this.getCurrentSpecText())
                .fontSize(12)
                .fontColor('#86868b')

              // 价格和库存
              Row({ space: 8 }) {
                Text(`¥${this.getCurrentPrice().toFixed(2)}`)
                  .fontSize(18)
                  .fontColor('#ff3b30')
                  .fontWeight(600)

                Text(`库存 ${this.getCurrentStock()} 件`)
                  .fontSize(12)
                  .fontColor('#86868b')
              }
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#f9f9f9')
          .borderRadius(12)

          // 规格选择
          if (this.localProductList.length > 0) {
            Column({ space: 12 }) {
              Text('规格')
                .fontSize(15)
                .fontWeight(500)
                .fontColor('#1d1d1f')
                .lineHeight(20)

              Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
                ForEach(this.localProductList, (product: Product, index: number) => {
                  Text(product.specifications?.join(' ') || '')
                    .fontSize(14)
                    .fontColor(this.selectedProductIndex === index ? '#ffffff' : '#1d1d1f')
                    .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                    .backgroundColor(this.selectedProductIndex === index ? '#0071e3' : '#f5f5f7')
                    .borderRadius(8)
                    .onClick(() => this.selectProduct(index))
                })
              }
            }
            .alignItems(HorizontalAlign.Start)
            .width('100%')
          } else {
            Text('暂无规格可选')
              .fontSize(14)
              .fontColor('#86868b')
              .lineHeight(20)
          }

          // 数量
          Row() {
            Text('数量')
              .fontSize(15)
              .fontWeight(500)
              .fontColor('#1d1d1f')
              .lineHeight(20)

            Blank()

            Row({ space: 0 }) {
              Text('-')
                .textAlign(TextAlign.Center)
                .fontSize(20)
                .fontColor('#1d1d1f')
                .backgroundColor('#f5f5f7')
                .width(32)
                .height(32)
                .borderRadius(8)
                .onClick(() => this.changeQuantity(-1))

              Text(this.quantity.toString())
                .fontSize(15)
                .fontColor('#1d1d1f')
                .width(48)
                .textAlign(TextAlign.Center)
                .height(32)

              Text('+')
                .textAlign(TextAlign.Center)
                .fontSize(20)
                .fontColor('#1d1d1f')
                .backgroundColor('#f5f5f7')
                .width(32)
                .height(32)
                .borderRadius(8)
                .onClick(() => this.changeQuantity(1))
            }
          }
          .width('100%')
        }
        .padding(16)
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      // 底部按钮
      Row({ space: 12 }) {
        Button('加入购物车')
          .fontSize(15)
          .fontWeight(500)
          .fontColor('#ffffff')
          .layoutWeight(1)
          .height(44)
          .backgroundColor('#ff9500')
          .borderRadius(22)
          .enabled(!this.isLoading)
          .onClick(() => this.handleAddToCart())

        Button('立即购买')
          .fontSize(15)
          .fontWeight(500)
          .fontColor('#ffffff')
          .layoutWeight(1)
          .height(44)
          .backgroundColor('#ff3b30')
          .borderRadius(22)
          .onClick(() => this.handleFastBuy())
      }
      .padding({ left: 16, right: 16, bottom: 16, top: 12 })
    }
    .width('100%')
    .height(560)
    .backgroundColor(Color.White)
    .borderRadius({ topLeft: 20, topRight: 20 })
  }
}
