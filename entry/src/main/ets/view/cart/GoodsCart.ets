import {
  deleteCart, getCartList, updateCart
} from '../../api/cart/cart'
import { ApiResponse, NoApi } from '../../viewModel'
import { CartItem, CartList,
  CheckoutParams, DeleteCartParams, UpdateCartParams } from '../../viewModel/cart/cart'
import { Prompt} from '@kit.ArkUI'
import PreferencesUtil from '../../utils/PreferencesUtil'

@Component
export struct GoodsCart {
  // 状态（严格类型）
  @State cartList: CartItem[] = []
  @State loading: boolean = true
  @State refreshing: boolean = false
  @State isEditMode: boolean = false
  @State totalPrice: number = 0
  @State selectedCount: number = 0
  @State isLoggedIn: boolean = false
  private  router = this.getUIContext().getRouter()
  private prompt = this.getUIContext().getPromptAction()
  @State private deleteProductIds: number[] = []

  aboutToAppear(): void {
    this.checkLoginStatus()
  }

  onPageShow(): void {
    this.checkLoginStatus()
  }

  async checkLoginStatus(): Promise<void> {
    const token = await PreferencesUtil.getToken()
    this.isLoggedIn = !!token
    if (this.isLoggedIn) {
      this.fetchCartList()
    } else {
      this.loading = false
    }
  }

  // 获取购物车
  private async fetchCartList(): Promise<void> {
    this.loading = true
    try {
      const res: ApiResponse<CartList> = await getCartList()
      console.log('购物车列表' + JSON.stringify(res.data.cartList))
      if (res.errno === 0) {
        this.cartList = res.data.cartList || []
        // 初始化 checked（后端不返回时默认 false）
        this.cartList.forEach((item: CartItem) => {
          item.checked = item.checked ?? false
        })
        this.updateTotalAndCount()
      } else if (res.errno === 501) {
        this.isLoggedIn = false
        this.cartList = []
        this.prompt.showToast({ message: '请先登录' })
      }
    } catch (error) {
      console.error('获取购物车失败', error)
      this.prompt.showToast({ message: '获取购物车失败' })
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
      } else {
        this.prompt.showToast({ message: '更新数量失败' })
        await this.fetchCartList() // 回滚
      }
    } catch (error) {
      console.error('更新数量失败', error)
      this.prompt.showToast({ message: '网络请求失败' })
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

  // 删除确认弹窗
  private showDeleteDialog(): void {
    this.prompt.showDialog({
      message: '确定删除选中商品？',
      buttons: [
        { text: '取消', color: '#999999' },
        { text: '确定', color: '#ee0a24' }
      ]
    }, (err,data) => {
      if (err) {
        console.error(`showDialog args error is ${JSON.stringify(err)}`);
      } else if (data.index === 1) {
        // 点击确定
        this.handleDelete()
      }
    })
  }

  // 执行删除
  private async handleDelete(): Promise<void> {
    try {
      const params: DeleteCartParams = { productIds: this.deleteProductIds }
      const res: ApiResponse<CartList> = await deleteCart(params)
      if (res.errno === 0) {
        this.prompt.showToast({ message: '删除成功' })
        await this.fetchCartList()
      } else {
        this.prompt.showToast({ message: res.errmsg || '删除失败' })
      }
    } catch (error) {
      console.error('删除失败', error)
      this.prompt.showToast({ message: '网络请求失败' })
    }
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
      // 跳转到确认订单页,传递 cartIds 参数
      this.router.pushUrl({
        url: 'view/mine/CheckoutPage',
        params: { cartIds: cartIds.join(',') }
      })
        .catch((err:string) => console.error('跳转结算页面失败:', err))
    } catch (error) {
      console.error('跳转失败', error)
      this.prompt.showToast({ message: '跳转失败' })
    }
  }

  @Builder
  buildEmptyCart() {
    Column() {
      Image($r('app.media.startIcon'))
        .width(120)
        .height(120)
        .opacity(0.3)
        .margin({ bottom: 16 })
      Text('购物车还是空的')
        .fontSize(16)
        .fontColor('#999999')
        .margin({ bottom: 24 })
      Button('去逛逛')
        .fontSize(16)
        .fontColor(Color.White)
        .backgroundColor('#ff6bbfff')
        .borderRadius(20)
        .padding({ left: 32, right: 32, top: 12, bottom: 12 })
        .onClick(() => {
          this.router.pushUrl({ url: 'pages/Index' })
            .catch((err:string) => console.error('跳转首页失败:', err))
        })
    }
    .alignItems(HorizontalAlign.Center)
    .layoutWeight(1)
  }

  @Builder
  buildCartItem(item: CartItem) {
    Row({ space: 12 }) {
      Checkbox()
        .select(item.checked)
        .width(22)
        .height(22)
        .onClick(() => this.toggleItem(item))

      Image(item.picUrl)
        .width(80)
        .height(80)
        .borderRadius(8)

      Column({ space: 4 }) {
        Text(item.goodsName)
          .fontSize(14)
          .fontColor('#333333')
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
            Row({ space: 0 }) {
              Text('-')
                .textAlign(TextAlign.Center)
                .fontSize(16)
                .fontColor('#666666')
                .backgroundColor('#ffe2e2e2')
                .width(28)
                .height(28)
                .borderRadius(4)
                .onClick(() => {
                  if (item.number > 1) {
                    this.handleNumberChange(item, item.number - 1)
                  }
                })

              Text(item.number.toString())
                .fontSize(14)
                .fontColor('#333333')
                .width(32)
                .textAlign(TextAlign.Center)

              Text('+')
                .textAlign(TextAlign.Center)

                .fontSize(16)
                .fontColor('#666666')
                .backgroundColor('#ffe5e5e5')
                .width(28)
                .height(28)
                .borderRadius(4)
                .onClick(() => this.handleNumberChange(item, item.number + 1))
            }
            .alignItems(VerticalAlign.Center)
          } else {
            Button('删除')
              .fontSize(14)
              .fontColor('#ee0a24')
              .backgroundColor('#f5f5f5')
              .height(28)
              .borderRadius(4)
              .onClick(() => this.handleRemoveItem(item))
          }
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .alignItems(VerticalAlign.Center)
    .padding(12)
    .backgroundColor('#ffffff')
    .borderRadius(8)
    .margin({ bottom: 8 })
  }

  build() {
    Column() {
      // 导航栏
      Row() {
        Text('购物车')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .layoutWeight(1)

        Text(this.isEditMode ? '完成' : '编辑')
          .fontSize(16)
          .fontColor('#666666')
          .onClick(() => {
            this.isEditMode = !this.isEditMode
          })
      }
      .alignItems(VerticalAlign.Center)
      .height(56)
      .width('100%')
      .padding({ left: 16, right: 16 })
      .backgroundColor('#ffffff')

      if (!this.isLoggedIn) {
        // 未登录状态
        Column() {
          Image($r('app.media.startIcon'))
            .width(120)
            .height(120)
            .opacity(0.3)
            .margin({ bottom: 16 })
          Text('请先登录')
            .fontSize(16)
            .fontColor('#999999')
            .margin({ bottom: 24 })
          Button('去登录')
            .fontSize(16)
            .fontColor(Color.White)
            .backgroundColor('#ff6bbfff')
            .borderRadius(20)
            .padding({ left: 32, right: 32, top: 12, bottom: 12 })
            .onClick(() => {
              this.router.pushUrl({ url: 'view/login/LoginPage' })
                .catch((err:string) => console.error('跳转登录页面失败:', err))
            })
        }
        .alignItems(HorizontalAlign.Center)
        .layoutWeight(1)
      } else if (this.loading) {
        // 加载中
        LoadingProgress()
          .width(48)
          .height(48)
          .color('#ff6bbfff')
          .margin({ top: 100 })
      } else if (this.cartList.length === 0) {
        // 空购物车
        this.buildEmptyCart()
      } else {
        // 购物车列表
        Scroll() {
          Column() {
              ForEach(this.cartList, (item: CartItem) => {
                this.buildCartItem(item)
              })
          }
          .justifyContent(FlexAlign.Start)
          .height('100%')
          .padding(12)

        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)
      }

      // 底部栏
      if (this.cartList.length > 0) {
        Row() {

          // 价格 / 操作
          if (!this.isEditMode) {
            Text(`合计：¥${this.totalPrice.toFixed(2)}`)
              .fontSize(16)
              .fontColor('#ee0a24')
              .fontWeight(FontWeight.Medium)
              .layoutWeight(1)
              .textAlign(TextAlign.End)
              .margin({ right: 12 })

            Button(`去结算(${this.selectedCount})`)
              .fontSize(16)
              .fontColor(Color.White)
              .backgroundColor('#ff6bbfff')
              .borderRadius(20)
              .padding({ left: 20, right: 20, top: 10, bottom: 10 })
              .enabled(this.selectedCount > 0)
              .onClick(() => this.handleCheckout())
          } else {
            Button(`删除(${this.selectedCount})`)
              .fontSize(16)
              .fontColor(Color.White)
              .backgroundColor('#ff6bbfff')
              .borderRadius(20)
              .padding({ left: 20, right: 20, top: 10, bottom: 10 })
              .enabled(this.selectedCount > 0)
              .onClick(() => this.handleBatchRemove())
          }
        }
        .alignItems(VerticalAlign.Top)
        .height(60)
        .padding({ left: 16, right: 16 })
        .backgroundColor('#ffffff')
        .border({ width: { top: 0.5 }, color: '#f0f0f0' })
      }
    }
    .padding({top:30})
    .width('100%')
    .height('100%')
    .backgroundColor('#f7f8fa')
  }
}
