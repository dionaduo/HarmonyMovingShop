import { Product, SpecificationGroup } from '../../viewModel/goods/goodsDetail';
import { addToCart, fastAddToCart, addCartParams } from '../../api/cart/cart';

@CustomDialog
@Component
export struct AddToCartDialog {
  private dialogController: CustomDialogController;
  @Prop specificationList: SpecificationGroup[] = [];
  @Prop productList: Product[] = [];
  @Prop goodsId: number = 0;
  @Prop defaultPrice: number = 0;
  // 回调函数
  onAddToCart?: (productId: number, quantity: number) => void;
  onFastBuy?: (cartId: number, quantity: number) => void;
  @State selectedProductIndex: number = 0;
  @State quantity: number = 1;
  @State isLoading: boolean = false;
  private prompt = this.getUIContext().getPromptAction()

  aboutToAppear(): void {
    console.log('AddToCartDialog aboutToAppear')
    console.log('specificationList:', JSON.stringify(this.specificationList))
    console.log('productList:', JSON.stringify(this.productList))
    console.log('goodsId:', this.goodsId)
    console.log('defaultPrice:', this.defaultPrice)
  }

  // 安全获取当前选中规格
  private get currentProduct(): Product {
    console.log('currentProduct - productList.length:', this.productList.length, 'selectedProductIndex:', this.selectedProductIndex)
    if (this.productList.length === 0 || this.selectedProductIndex >= this.productList.length) {
      console.log('currentProduct - 返回空对象')
      return {} as Product;
    }
    const product = this.productList[this.selectedProductIndex];
    console.log('currentProduct - 返回:', JSON.stringify(product))
    return product;
  }

  private get currentPrice(): number {
    return this.currentProduct?.price ?? this.defaultPrice;
  }

  private get currentStock(): number {
    return this.currentProduct?.number ?? 999;
  }

  private get currentSpecText(): string {
    const specs = this.currentProduct?.specifications || [];
    console.log('currentSpecText - specs:', JSON.stringify(specs))
    if (specs.length === 0) {
      return '请选择规格';
    }
    return specs.join(' ');
  }

  private selectProduct(index: number): void {
    console.log('selectProduct - index:', index, 'productList.length:', this.productList.length)
    if (index >= 0 && index < this.productList.length) {
      this.selectedProductIndex = index;
      this.quantity = 1;
      console.log('选中规格:', this.productList[index].specifications)
    }
  }

  private changeQuantity(delta: number): void {
    let newQty = this.quantity + delta;
    if (newQty < 1) newQty = 1;
    if (newQty > this.currentStock) {
      this.prompt.showToast({ message: `库存不足，仅剩 ${this.currentStock} 件` });
      return;
    }
    this.quantity = newQty;
  }

  private async handleAddToCart(): Promise<void> {
    const product = this.currentProduct;
    console.log('handleAddToCart - product:', JSON.stringify(product))
    console.log('handleAddToCart - product.id:', product?.id)
    console.log('handleAddToCart - goodsId:', this.goodsId)
    console.log('handleAddToCart - quantity:', this.quantity)

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
    const product = this.currentProduct;
    if (!product || !product.id) {
      this.prompt.showToast({ message: '请先选择规格' });
      return;
    }

    if (this.goodsId === 0) {
      this.prompt.showToast({ message: '商品信息错误' });
      return;
    }

    try {
      const params: addCartParams = {
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
        Column({ space: 24 }) {
          // 规格选择
          if (this.productList.length > 0) {
            Column({ space: 8 }) {
              Text('规格')
                .fontSize(15)
                .fontWeight(500)
                .fontColor('#1d1d1f')
                .lineHeight(20)

              Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
                ForEach(this.productList, (product: Product, index: number) => {
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
          } else {
            Text('暂无规格可选')
              .fontSize(14)
              .fontColor('#86868b')
              .lineHeight(20)
          }

          // 数量
          Column({ space: 8 }) {
            Text('数量')
              .fontSize(15)
              .fontWeight(500)
              .fontColor('#1d1d1f')
              .lineHeight(20)

            Row({ space: 0 }) {
              Button('-')
                .fontSize(20)
                .fontColor('#ff0c0c1f')
                .backgroundColor('#f5f5f7')
                .width(32)
                .height(32)
                .borderRadius(8)
                .onClick(() => this.changeQuantity(-1))

              Text(this.quantity.toString())
                .fontSize(15)
                .fontColor('#1d1d1f')
                .width(40)
                .textAlign(TextAlign.Center)
                .height(32)

              Button('+')
                .fontSize(20)
                .fontWeight(FontWeight.Bolder)
                .fontColor('#86868b')
                .width(32)
                .height(32)
                .borderRadius(8)
                .onClick(() => this.changeQuantity(1))
            }
            .width(104)
          }
          .alignItems(HorizontalAlign.Start)
        }
        .padding(20)
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
          .backgroundColor('#0071e3')
          .borderRadius(10)
          .enabled(!this.isLoading)
          .onClick(() => this.handleAddToCart())

        Button('立即购买')
          .fontSize(15)
          .fontWeight(500)
          .fontColor('#ffffff')
          .layoutWeight(1)
          .height(44)
          .backgroundColor('#0071e3')
          .borderRadius(10)
          .onClick(() => this.handleFastBuy())
      }
      .padding({ left: 20, right: 20, bottom: 12, top: 12 })
    }
    .width('100%')
    .height(440)
    .backgroundColor(Color.White)
    .borderRadius(20)
  }
}
