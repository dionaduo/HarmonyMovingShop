import { Prompt } from '@kit.ArkUI';
import { Product, SpecificationGroup } from '../../viewModel/goods/goodsDetail';
import { addToCart, fastAddToCart, addCartParams } from '../../api/cart/cart';
import { ApiResponse } from '../../viewModel';
// 注意：这里不再需要导入 AddCart，因为 API 返回的是 number

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

  // 安全获取当前选中规格
  private get currentProduct(): Product{
    if (this.productList.length === 0 || this.selectedProductIndex >= this.productList.length) {
      return {} as Product;
    }
    return this.productList[this.selectedProductIndex];
  }

  private get currentPrice(): number {
    return this.currentProduct?.price ?? this.defaultPrice;
  }

  private get currentStock(): number {
    return this.currentProduct?.number ?? 999;
  }

  private get currentSpecText(): string {
    return this.currentProduct?.specifications?.join(' · ') || '请选择规格';
  }

  private selectProduct(index: number): void {
    if (index >= 0 && index < this.productList.length) {
      this.selectedProductIndex = index;
      this.quantity = 1;
    }
  }

  private changeQuantity(delta: number): void {
    let newQty = this.quantity + delta;
    if (newQty < 1) newQty = 1;
    if (newQty > this.currentStock) {
      Prompt.showToast({ message: `库存不足，仅剩 ${this.currentStock} 件` });
      return;
    }
    this.quantity = newQty;
  }

  private async handleAddToCart(): Promise<void> {
    const product = this.currentProduct;
    if (!product || !product.id) {
      Prompt.showToast({ message: '请先选择规格' });
      return;
    }

    if (this.goodsId === 0) {
      Prompt.showToast({ message: '商品信息错误' });
      return;
    }

    this.isLoading = true;

    try {
      const params: addCartParams = {
        goodsId: this.goodsId,
        productId: product.id,
        number: this.quantity
      };

      // 【修复点1】API 返回 data 是 number，所以泛型使用 number
      const res = await addToCart(params);

      if (res.errno === 0) {
        Prompt.showToast({ message: '已加入购物车' });
        // 通知父组件刷新购物车数量
        this.onAddToCart?.(product.id, this.quantity);
        this.dialogController.close();
      } else {
        Prompt.showToast({ message: res.errmsg || '加入购物车失败' });
      }
    } catch (error) {
      console.error('加入购物车失败:', error);
      Prompt.showToast({ message: '加入购物车失败，请重试' });
    } finally {
      this.isLoading = false;
    }
  }

  private async handleFastBuy(): Promise<void> {
    const product = this.currentProduct;
    if (!product || !product.id) {
      Prompt.showToast({ message: '请先选择规格' });
      return;
    }

    if (this.goodsId === 0) {
      Prompt.showToast({ message: '商品信息错误' });
      return;
    }

    try {
      const params: addCartParams = {
        goodsId: this.goodsId,
        productId: product.id,
        number: this.quantity
      };

      // 【修复点2】API 返回 data 是 number，所以泛型使用 number
      const res = await fastAddToCart(params);

      if (res.errno === 0 && res.data) {
        // 【修复点3】直接使用 res.data，它本身就是 cartId (数字)，不需要 .cartId 属性
        const cartId = res.data;

        if (cartId) {
          // 通知父组件跳转到结算页面
          this.onFastBuy?.(cartId, this.quantity);
          this.dialogController.close();
        } else {
          Prompt.showToast({ message: '购买失败，请重试' });
        }
      } else {
        Prompt.showToast({ message: res.errmsg || '购买失败' });
      }
    } catch (error) {
      console.error('立即购买失败:', error);
      Prompt.showToast({ message: '购买失败，请重试' });
    }
  }

  build() {
    Column({ space: 0 }) {
      // 标题栏
      Row() {
        Text('选择规格')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)

        Image($r('app.media.right_arrow'))
          .width(24)
          .height(24)
          .fillColor('#CCCCCC')
          .rotate({ angle: 180 })
          .onClick(() => this.dialogController.close())
      }
      .width('100%')
      .height(56)
      .padding({ left: 20, right: 20 })
      .backgroundColor(Color.White)

      Scroll() {
        Column({ space: 20 }) {
          // 当前选中
          Row({ space: 12 }) {
            Text(this.currentSpecText)
              .fontSize(15)
              .fontColor('#ee0a24')
              .layoutWeight(1)
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            Text(`¥${this.currentPrice}`)
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#ee0a24')
          }
          .padding({ left: 20, right: 20 })

          Divider().strokeWidth(0.5).color('#F0F0F0')

          // 规格选择
          if (this.productList.length > 0) {
            Column({ space: 12 }) {
              Text('规格').fontSize(15).fontColor('#666666').padding({ left: 20 })

              Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
                ForEach(this.productList, (product: Product, index: number) => {
                  Text(product.specifications?.join(' ') || '')
                    .fontSize(14)
                    .padding({
                      left: 16,
                      right: 16,
                      top: 10,
                      bottom: 10
                    })
                    .backgroundColor(this.selectedProductIndex === index ? '#ee0a24' : '#F5F7FA')
                    .fontColor(this.selectedProductIndex === index ? Color.White : '#333333')
                    .borderRadius(20)
                    .margin({ right: 10, bottom: 10 })
                    .onClick(() => this.selectProduct(index))
                })
              }
              .padding({ left: 20, right: 20 })
            }
          } else {
            Text('暂无规格可选')
              .fontSize(14)
              .fontColor('#999999')
              .padding({ left: 20 })
          }

          // 数量
          Row({ space: 20 }) {
            Text('数量').fontSize(15).fontColor('#666666')
            Blank()
            Row() {
              Button('-').width(40).height(40).backgroundColor('#F5F7FA').onClick(() => this.changeQuantity(-1))
              Text(this.quantity.toString()).width(50).textAlign(TextAlign.Center).fontSize(17)
              Button('+').width(40).height(40).backgroundColor('#F5F7FA').onClick(() => this.changeQuantity(1))
            }
          }
          .padding({ left: 20, right: 20 })
        }
        .padding({ top: 16 })
      }
      .layoutWeight(1)

      // 底部按钮
      Row({ space: 12 }) {
        Button('加入购物车')
          .layoutWeight(1)
          .height(52)
          .backgroundColor('#FF9800')
          .fontColor(Color.White)
          .borderRadius(26)
          .enabled(!this.isLoading)
          .onClick(() => this.handleAddToCart())

        Button('立即购买')
          .layoutWeight(1)
          .height(52)
          .backgroundColor('#ee0a24')
          .fontColor(Color.White)
          .borderRadius(26)
          .onClick(() => this.handleFastBuy())
      }
      .padding({
        left: 20,
        right: 20,
        bottom: 24,
        top: 12
      })
      .backgroundColor(Color.White)
    }
  }
}