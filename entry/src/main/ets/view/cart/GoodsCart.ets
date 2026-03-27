import {
  checkoutCart, deleteCart, getCartList, updateCart
} from '../../api/cart/cart'
import { ApiResponse, NoApi } from '../../viewModel'
import { CartItem, CartList,
  Checkout,
  CheckoutParams, DeleteCartParams, UpdateCartParams } from '../../viewModel/cart/cart'
import { Prompt} from '@kit.ArkUI'

@Component
export struct GoodsCart {
  // 状态（严格类型）
  @State cartList: CartItem[] = []
  @State loading: boolean = true
  @State refreshing: boolean = false
  @State isEditMode: boolean = false
  @State totalPrice: number = 0
  @State selectedCount: number = 0
  private  router = this.getUIContext().getRouter()
  private prompt = this.getUIContext().getPromptAction()
  @State private deleteProductIds: number[] = []

  aboutToAppear(): void {
    this.fetchCartList()
  }

  // 获取购物车
  private async fetchCartList(): Promise<void> {
    this.loading = true
    try {
      const res: ApiResponse<CartList> = await getCartList()
      if (res.errno === 0) {
        this.cartList = res.data.cartList || []
        // 初始化 checked（后端不返回时默认 false）
        this.cartList.forEach((item: CartItem) => {
          item.checked = item.checked ?? false
        })
        this.updateTotalAndCount()
      }
    } catch (error) {
      console.error('获取购物车失败')
    } finally {
      this.loading = false
      this.refreshing = false
    }
  }

  // 更新合计和选中数量
  private updateTotalAndCount(): void {
    let price = 0
    let count = 0
    this.cartList.forEach((item: CartItem) => {
      if (item.checked) {
        price += item.price * item.number
        count++
      }
    })
    this.totalPrice = price
    this.selectedCount = count
  }

  // 数量变化
  private async handleNumberChange(item: CartItem, newNumber: number): Promise<void> {
    if (newNumber < 1) return
    try {
      const params: UpdateCartParams = {
        id: item.id,
        number: newNumber,
        goodsId: item.goodsId,
        productId: item.productId
      }
      const res: NoApi = await updateCart(params) // NoApi 实际返回 {errno}
      if (res.errno === 0) {
        item.number = newNumber
        this.updateTotalAndCount()
      }
    } catch (error) {
      console.error('更新数量失败')
      await this.fetchCartList() // 回滚
    }
  }

  // 单选
  private toggleItem(item: CartItem): void {
    item.checked = !item.checked
    this.updateTotalAndCount()
  }

  // 全选
  private toggleAll(): void {
    const newVal = !this.cartList.every((item: CartItem) => item.checked)
    this.cartList.forEach((item: CartItem) => {
      item.checked = newVal
    })
    this.updateTotalAndCount()
  }

  // 删除单个（编辑模式）
  private handleRemoveItem(item: CartItem): void {
    this.deleteProductIds = [item.productId]
    this.showDeleteDialog()
  }

  // 批量删除
  private handleBatchRemove(): void {
    if (this.selectedCount === 0) return
    this.deleteProductIds = this.cartList
      .filter((item: CartItem) => item.checked)
      .map((item: CartItem) => item.productId)
    this.showDeleteDialog()
  }

  // 删除确认弹窗（简单模拟，使用 prompt 或自定义 Dialog，这里用内置 prompt）
  private showDeleteDialog(): void {
    this.prompt.openToast({
      message: '确定删除选中商品？',
    }).then(async (index: number) => {
      if (index === 1) {
        try {
          const params: DeleteCartParams = { productIds: this.deleteProductIds }
          const res = await deleteCart(params)
          if (res.productIds) {
            this.fetchCartList()
          }
        } catch (error) {
          console.error('删除失败')
        }
      }
    })
  }

  // 去结算
  private async handleCheckout(): Promise<void> {
    if (this.selectedCount === 0) {
      this.prompt.showToast({ message: '请选择商品' })
      return
    }
    const cartIds: number[] = this.cartList
      .filter((item: CartItem) => item.checked)
      .map((item: CartItem) => item.id)

    try {
      const params: CheckoutParams = { cartIds: cartIds.join(',') }
      const res: ApiResponse<Checkout> = await checkoutCart(params) // 实际返回 Checkout
      if (res.errno === 0) {
        // 跳转到确认订单页（根据实际路由框架替换）
        this.router.pushUrl({ url: '/pages/checkout' })
      }
    } catch (error) {
      console.error('结算失败')
    }
  }




  build() {
    Column() {
      // 导航栏 - 修正为链式调用
      Row() {
        Text('购物车')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)

        Text(this.isEditMode ? '完成' : '编辑')
          .fontSize(16)
          .fontColor('#ee0a24')
          .onClick(() => {
            this.isEditMode = !this.isEditMode
          })
      }
      .alignItems(VerticalAlign.Center) // 正确规范写法
      .height(56)
      .width('100%')
      .padding({ left: 16, right: 16 })
      .backgroundColor('#ffffff')

      // 内容区
      if (this.loading) {
        LoadingProgress()
          .width(48)
          .height(48)
          .margin({ top: 100 })
      } else if (this.cartList.length === 0) {
        // 空购物车 - 修正为链式调用
        Column() {
          Image($r('app.media.servicer'))
            .width(120)
            .height(120)
            .margin({ bottom: 16 })
          Text('购物车还是空的')
            .fontSize(16)
            .fontColor('#999999')
          Button('去逛逛')
            .type(ButtonType.Normal)
            .backgroundColor('#ee0a24')
            .onClick(() => this.router.pushUrl({ url: '/pages/home' }))
            .margin({ top: 24 })
        }
        .alignItems(HorizontalAlign.Center) // 正确规范写法
        .layoutWeight(1)
      } else {
        Scroll() {
          Column() {
            ForEach(this.cartList, (item: CartItem) => {
              // 商品项 - 修正为链式调用
              Row({ space: 12 }) {
                Checkbox({ })
                  .onChange(() => this.toggleItem(item))
                  .width(22)
                  .height(22)

                Image(item.picUrl)
                  .width(80)
                  .height(80)
                  .borderRadius(8)

                Column({  space: 4 }) {
                  Text(item.goodsName)
                    .fontSize(14)
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Text(item.specifications?.join(' ') || '标准规格')
                    .fontSize(12)
                    .fontColor('#999999')

                  Row() {
                    Text(`¥${item.price}`)
                      .fontSize(16)
                      .fontColor('#ee0a24')
                      .fontWeight(FontWeight.Medium)

                    if (!this.isEditMode) {
                      // 简易步进器
                      Row() {
                        Button('-')
                          .width(28)
                          .height(28)
                          .onClick(() => this.handleNumberChange(item, item.number - 1))

                        Text(`${item.number}`)
                          .width(40)
                          .textAlign(TextAlign.Center)

                        Button('+')
                          .width(28)
                          .height(28)
                          .onClick(() => this.handleNumberChange(item, item.number + 1))
                      }
                      .alignItems(VerticalAlign.Center) // 正确规范写法
                    } else {
                      Button('删除')
                        .type(ButtonType.Normal)
                        .backgroundColor('#ffffff')
                        .fontColor('#ee0a24')
                        .onClick(() => this.handleRemoveItem(item))
                    }
                  }
                  .alignItems(VerticalAlign.Center) // 正确规范写法
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
              }
              .alignItems(VerticalAlign.Center) // 正确规范写法
              .padding(12)
              .backgroundColor('#ffffff')
              .borderRadius(8)
              .margin({ bottom: 8 })
            })
          }
          .padding(12)
        }
        .layoutWeight(1)
      }

      // 底部栏 - 修正为链式调用
      if (this.cartList.length > 0) {
        Row() {
          // 全选 - 修正为链式调用
          Row({ space: 8 }) {
            Checkbox()
              .onChange(() => this.toggleAll())
            Text('全选')
              .fontSize(14)
          }
          .alignItems(VerticalAlign.Center) // 正确规范写法

          // 价格 / 操作
          if (!this.isEditMode) {
            Text(`合计：¥${this.totalPrice.toFixed(2)}`)
              .fontSize(16)
              .fontColor('#ee0a24')
              .layoutWeight(1)
              .textAlign(TextAlign.End)

            Button(`去结算(${this.selectedCount})`)
              .type(ButtonType.Normal)
              .backgroundColor(this.selectedCount > 0 ? '#ee0a24' : '#cccccc')
              .enabled(this.selectedCount > 0)
              .onClick(() => this.handleCheckout())
          } else {
            Button(`删除(${this.selectedCount})`)
              .type(ButtonType.Normal)
              .backgroundColor(this.selectedCount > 0 ? '#ee0a24' : '#cccccc')
              .enabled(this.selectedCount > 0)
              .onClick(() => this.handleBatchRemove())
          }
        }
        .alignItems(VerticalAlign.Center) // 正确规范写法
        .height(60)
        .padding({ left: 16, right: 16 })
        .backgroundColor('#ffffff')
        .border({ width: 1, color: '#f0f0f0' })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}
