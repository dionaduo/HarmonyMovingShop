import { getOrderList } from "../api/mine/order";
import { OrderGoodsItem } from "../component/mine/OrderGoodsItem";
import { OrderListItem, OrderGoodsItem as OrderGoodsItemType } from "../viewModel/mine/order"


interface ITitle {
  title: string;
  color: Color;
}

@Entry
@Component
export struct OrderListPage {
  @State currentTabIndex: number = 0;
  @State currTabImage: Resource[] = [
    $r('app.media.MF'),
    $r('app.media.MU'),
    $r('app.media.MC'),
    $r('app.media.MK'),
    $r('app.media.wxts')
  ]
  @State titleList: ITitle[] = [
    { title: '全部', color: Color.Red },
    { title: '待付款', color: Color.Blue },
    { title: '待发货', color: Color.Green },
    { title: '待收货', color: Color.Orange },
    { title: '待评价', color: Color.Pink }
  ]
  @State orderList: OrderListItem[] = []
  @State isLoading: boolean = true

  private router = this.getUIContext().getRouter()

  aboutToAppear(): void {
    this.loadOrderList(this.currentTabIndex)
  }

  async loadOrderList(showType: number): Promise<void> {
    this.isLoading = true
    try {
      const res = await getOrderList(showType)
      console.log(JSON.stringify(res))
      if (res.errno === 0) {
        this.orderList = res.data.list
        console.log(JSON.stringify(this.orderList))
      }
    } catch (error) {
      console.error('加载订单列表失败:', error)
    } finally {
      this.isLoading = false
    }
  }

  @Builder
  tabItem(index: number, title: string, icon: Resource, selectedIcon: Resource) {
    Column() {
      Text(title).fontSize(16).fontColor(index === this.currentTabIndex ? '#333333' : '#999999')
      Divider()
        .width(35)
        .strokeWidth(2)
        .margin({ top: 6, bottom: 4 })
        .backgroundColor(index === this.currentTabIndex ? Color.Red : Color.Transparent)
    }
  }

  @Builder
  orderListBuilder() {
    Column() {
      ForEach(this.orderList, (item: OrderListItem, index: number) => {
        Column() {
          ForEach(item.goodsList, (goods: OrderGoodsItemType, goodsIndex: number) => {
            OrderGoodsItem({
              orderSn: item.orderSn,
              picUrl: goods.picUrl,
              goodsName: goods.goodsName,
              actualPrice: item.actualPrice,
              specifications: goods.specifications,
              number: goods.number,
              orderStatusText: item.orderStatusText,
              handleOption: item.handleOption
            })
          })
        }
        .width('100%').margin({ top: 8 })
      })
    }.width('100%').margin({ top: 8 })
  }

  build() {
    Column() {
      Row() {
        Text('< 返回')
          .fontSize(18)
          .fontColor('#007AFF')
          .margin({ left: 12 })
          .onClick(() => {
            this.router.back()
          })
      }.width('100%').height(44).backgroundColor(Color.White)
      Row() {
        ForEach(this.titleList, (item: ITitle, index: number) => {
          Column() {
            this.tabItem(index, item.title, this.currTabImage[index], this.currTabImage[4])
          }
          .layoutWeight(1)
          .onClick(() => {
            if (index !== this.currentTabIndex) {
              this.currentTabIndex = index
              this.loadOrderList(index)
            }
          })
        })
      }
      .width('100%')
      .height(44)
      .backgroundColor(Color.White)
      .border({ width: { bottom: 1 }, color: '#F0F0F0' })
      if (this.isLoading) {
        LoadingProgress()
          .width('100%')
          .height('100%')
          .color('#ff6bbfff')
      } else {
        Scroll() {
          this.orderListBuilder()
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)
        .backgroundColor('#F7F8FA')
      }
    }
    .padding({top :30})
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}
