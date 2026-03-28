import { checkoutCart } from '../../api/cart/cart'
import { getAddressList } from '../../api/address/address'
import { ApiResponse } from '../../viewModel'
import { AddressItem, CartItem, Checkout } from '../../viewModel/cart/cart'
import { OrderDetail, OrderInfo, OrderSubmitParams } from '../../viewModel/mine/order'
import { OrderParams } from '../../viewModel/mine/mine'
import { submitOrder } from '../../api/mine/order'

@Entry
@Component
export struct CheckoutPage {
  @State checkoutData: Checkout | null = null
  @State addressList: AddressItem[] = []
  @State selectedAddressId: number | null = null
  @State selectedCouponId: number | null = null
  @State message: string = ''
  @State cartId: string = ''  // 改为字符串类型,支持多个cartId
  @State isSubmitting: boolean = false
  @State addressDialogController: CustomDialogController | null = null
  private router = this.getUIContext().getRouter()

  aboutToAppear(): void {
    const params = this.getUIContext().getRouter().getParams() as Record<string, Object>

    // 判断是从购物车结算还是立即购买
    if (params?.cartId) {
      // 立即购买场景 - 单个 cartId
      this.cartId = params.cartId.toString()
      console.log('立即购买 - cartId:', this.cartId)
    } else if (params?.cartIds) {
      // 购物车结算场景 - 多个 cartId
      const cartIds = (params.cartIds as number[]) || []
      if (cartIds.length > 0) {
        this.cartId = cartIds.join(',')  // 多个cartId用逗号分隔
        console.log('购物车结算 - cartIds:', cartIds, '合并后的 cartId:', this.cartId)
      }
    }

    if (this.cartId) {
      this.loadCheckoutData()
    }
  }

  private async loadCheckoutData(): Promise<void> {
    try {
      const res: ApiResponse<Checkout> = await checkoutCart({ cartId: this.cartId })
      console.log('结算数据响应:', JSON.stringify(res))
      if (res.errno === 0 && res.data) {
        this.checkoutData = res.data
        // checkedAddress 是对象类型，直接使用
        if (res.data.checkedAddress) {
          this.selectedAddressId = res.data.checkedAddress.id
        }
      }
      // 同时获取地址列表用于弹窗选择
      const addrRes = await getAddressList()
      if (addrRes.errno === 0 && addrRes.data) {
        this.addressList = addrRes.data.list
      }
    } catch (e) {
      console.error('加载确认订单失败', e)
    }
  }

  private async handleSubmit(): Promise<void> {
    if (!this.selectedAddressId || !this.checkoutData) {
      console.error('缺少必要参数: 地址或订单数据')
      return
    }
    this.isSubmitting = true

    const params: OrderSubmitParams = {
      cartId: '0',
      addressId: this.selectedAddressId.toString(),
      couponId: this.selectedCouponId?.toString() || '0',
      userCouponId: '0',
      grouponRulesId: 0,
      grouponLinkId: 0,
      message: this.message
    }

    console.log('提交订单参数:', JSON.stringify(params))

    try {
      const res = await submitOrder(params)
      console.log('提交订单响应:', JSON.stringify(res))
      if (res.errno === 0 && res.data) {
        this.router.pushUrl({ url: 'pages/PaymentPage', params: { orderId: res.data.orderId } })
      } else {
        console.error('提交订单失败:', res.errmsg)
      }
    } catch (e) {
      console.error('提交订单失败', e)
    } finally {
      this.isSubmitting = false
    }
  }

  @Builder
  buildAddressItem(item: AddressItem) {
    Row({ space: 12 }) {
      Column() {
        Text(`${item.name} ${item.tel}`).fontSize(15).fontWeight(FontWeight.Medium)
        Text(`${item.province}${item.city}${item.county}${item.addressDetail}`).fontSize(13).fontColor('#666')
      }.layoutWeight(1)

      if (item.id === this.selectedAddressId) {
        Text('已选').fontSize(13).fontColor('#ee0a24')
      }
    }
    .padding(16)
    .onClick(() => {
      this.selectedAddressId = item.id
      this.addressDialogController?.close()
    })
  }

  @Builder
  buildAddressDialog() {
    Column() {
      Row() {
        Text('选择收货地址')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)

        Image($r('app.media.right_arrow'))
          .width(24)
          .height(24)
          .rotate({ angle: 180 })
          .onClick(() => {
            this.addressDialogController?.close()
          })
      }
      .width('100%')
      .padding(16)
      .borderRadius({ topLeft: 16, topRight: 16 })
      .backgroundColor(Color.White)

      List() {
        ForEach(this.addressList, (item: AddressItem) => {
          ListItem() {
            this.buildAddressItem(item)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#F5F5F5')
      .divider({
        strokeWidth: 1,
        color: '#F0F0F0',
        startMargin: 16,
        endMargin: 16
      })
    }
    .width('100%')
    .height('60%')
    .borderRadius({ topLeft: 16, topRight: 16 })
  }

  build() {
    Column() {
      // 导航栏
      Row() {
        Image($r('app.media.right_arrow')).width(24).height(24).onClick(() => this.router.back())
        Text('确认订单').fontSize(18).fontWeight(FontWeight.Medium).layoutWeight(1).textAlign(TextAlign.Center)
      }
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)

      Scroll() {
        Column({ space: 12 }) {
          // 收货地址
          Row({ space: 12 }) {
            Text('收货地址').fontSize(15).fontColor('#333').width(80)
            Text(this.getDisplayAddress())
              .fontSize(15)
              .layoutWeight(1)
            Image($r('app.media.right_arrow')).width(16).height(16)
          }
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(20)
          .onClick(() => {
            this.addressDialogController = new CustomDialogController({
              builder: this.buildAddressDialog,
              customStyle: true,
              alignment: DialogAlignment.Bottom
            })
            this.addressDialogController?.open()
          })

          // 商品列表
          Column() {
            Text('商品信息').fontSize(15).fontColor('#333').padding({ left: 16, top: 12 })
            ForEach(this.checkoutData?.checkedGoodsList || [], (item: CartItem) => {
              Row({ space: 12 }) {
                Image(item.picUrl).width(70).height(70).borderRadius(8)
                Column({ space: 4 }) {
                  Text(item.goodsName).fontSize(14).maxLines(2).textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text(item.specifications?.join(' ') || '标准').fontSize(12).fontColor('#999')
                  Row() {
                    Text(`¥${item.price}`).fontSize(16).fontColor('#ee0a24')
                    Text(`x${item.number}`).fontSize(14).fontColor('#666').layoutWeight(1).textAlign(TextAlign.End)
                  }
                }.layoutWeight(1)
              }
              .padding(16)
              .backgroundColor(Color.White)
              .borderRadius(12)
            })
          }
          .backgroundColor(Color.White)
          .borderRadius(20)

          // 金额明细
          Column({ space: 12 }) {
            Row(){
              Text('商品金额').fontSize(14)
              Text(`¥${this.checkoutData?.goodsTotalPrice?.toFixed(2) || '0.00'}`)
            }.justifyContent(FlexAlign.SpaceBetween)

            Row() {
              Text('运费').fontSize(14)
              Text(`¥${this.checkoutData?.freightPrice?.toFixed(2) || '0.00'}`)
            }.justifyContent(FlexAlign.SpaceBetween)

            Row() {
              Text('优惠券').fontSize(14)
              Text(`-¥${this.checkoutData?.couponPrice?.toFixed(2) || '0.00'}`).fontColor('#ee0a24')
            }.justifyContent(FlexAlign.SpaceBetween)
          }
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(20)

          // 订单备注
          Text('订单备注').fontSize(15).padding({ left: 16, top: 12 })
          TextInput({ text: this.message, placeholder: '选填：给卖家留言' })
            .height(100)
            .backgroundColor(Color.White)
            .borderRadius(12)
            .onChange((val) => this.message = val)
        }.height('100%')
        .justifyContent(FlexAlign.Start)
        .padding(12)
      }.height('100%')
      .layoutWeight(1)

      // 底部栏
      Row() {
        Text('合计：').fontSize(15)
        Text(`¥${this.checkoutData?.actualPrice?.toFixed(2) || '0.00'}`)
          .fontSize(18)
          .fontColor('#ee0a24')
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
        Button('提交订单')
          .type(ButtonType.Normal)
          .backgroundColor('#ee0a24')
          .fontColor(Color.White)
          .width(160)
          .height(48)
          .enabled(!this.isSubmitting)
          .onClick(() => this.handleSubmit())
      }
      .height(68)
      .padding({ left: 20, right: 16 })
      .backgroundColor(Color.White)
      .border({ width: { top: 1 }, color: '#f0f0f0' })
    }
    .padding({top:30})
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }

  // 获取显示的地址信息
  private getDisplayAddress(): string {
    if (!this.checkoutData?.checkedAddress) {
      return '请选择收货地址'
    }
    const addressData = this.checkoutData.checkedAddress
    return `${addressData.name} ${addressData.tel} ...`
  }
}