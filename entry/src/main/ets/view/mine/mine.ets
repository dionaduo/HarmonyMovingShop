import { getAddressList } from "../../api/address/address"
import { getCollectList, getUserInfo, logout } from "../../api/mine/mine"
import { UserInfo } from "../../viewModel/mine/user"

@Component
export struct mine {
  @State userInfo: UserInfo | null = null
  @State collectCount: number = 0
  @State addressCount: number = 0
  @State isLoading: boolean = true
  private router = this.getUIContext().getRouter()

  aboutToAppear(): void {
    this.loadData()
  }

  async loadData(): Promise<void> {
    try {
      const LoadData = await Promise.all([
        getUserInfo(),
        getCollectList({ page: 1, limit: 1 }),
        getAddressList()
      ])
      const userRes = LoadData[0];
      const collectRes = LoadData[1];
      const addressRes = LoadData[2];

      if (userRes.errno === 0) {
        this.userInfo = userRes.data
      }
      if (collectRes.errno === 0) {
        this.collectCount = collectRes.data.total
      }
      if (addressRes.errno === 0) {
        this.addressCount = addressRes.data.total
      }
    } catch (error) {
      console.error('加载我的页面数据失败:', error)
    } finally {
      this.isLoading = false
    }
  }

  // ==================== 用户信息头部 ====================
  @Builder
  buildUserInfo() {
    Row({ space: 16 }) {
      // 头像
      Stack() {
        Image(this.userInfo?.avatar || 'default_avatar.png')
          .width(68)
          .height(68)
          .borderRadius(34)
          .objectFit(ImageFit.Cover)
          .border({ width: 3, color: Color.White })
          .shadow({
            radius: 12,
            color: '#1A000000',
            offsetX: 0,
            offsetY: 4
          })
      }

      // 用户信息
      Column({ space: 6 }) {
        Text(this.userInfo?.nickname || '未登录')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Row({ space: 8 }) {
          Text(`ID: ${this.userInfo?.id?.toString() || '0'}`)
            .fontSize(13)
            .fontColor('#FFFFFFCC')

          if (this.userInfo?.level) {
            Text(`Lv.${this.userInfo.level}`)
              .fontSize(13)
              .fontColor('#FFFFFFCC')
          }
        }
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      // 设置按钮
      Stack() {
        Circle()
          .width(40)
          .height(40)
          .fill('#33FFFFFF')

        Image($r('app.media.startIcon'))
          .width(22)
          .height(22)
          .fillColor(Color.White)
      }
      .onClick(() => {
        this.router.pushUrl({ url: 'pages/SettingsPage' })
          .catch((err:string) => console.error('跳转设置页面失败:', err))
      })
    }
    .height(200)
    .linearGradient({
      angle: 135,
      colors: [['#ff6bd0ff',0.1], ['#ff8eb4ff',0.8]]
    })
    .borderRadius({ bottomLeft: 28, bottomRight: 28 })
    .shadow({
      radius: 20,
      color: '#33FF6B6B',
      offsetX: 0,
      offsetY: 6
    })

    .width('100%')
    .padding({
      left: 20,
      right: 20,
      top: 40,
      bottom: 24
    })
  }

  // ==================== 订单区域 ====================
  @Builder
  buildOrderSection() {
    Column() {
      // 标题栏
      Row() {
        Text('我的订单')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')

        Blank()

        Row({ space: 4 }) {
          Text('全部订单')
            .fontSize(14)
            .fontColor('#999999')

          Image($r('app.media.right_arrow'))
            .width(16)
            .height(16)
            .fillColor('#CCCCCC')
        }
        .onClick(() => this.goToOrderList())
      }
      .padding({
        left: 20,
        right: 20,
        top: 20,
        bottom: 12
      })
      .width('100%')

      // 订单状态
      Row({ space: 0 }) {
        this.buildOrderItem('待付款', 0, $r('app.media.fukuan'))
        this.buildOrderItem('待发货', 1, $r('app.media.fahuo'))
        this.buildOrderItem('待收货', 1, $r('app.media.shouhuo'))
        this.buildOrderItem('待评价', 1, $r('app.media.pingjia'))
      }
      .justifyContent(FlexAlign.SpaceAround)
      .padding({ left: 12, right: 12, bottom: 20 })
      .width('100%')
    }
    .width('100%')
    .backgroundColor(Color.White)
    .margin({ top: 12, left: 12, right: 12 })
    .borderRadius(20)
    .shadow({
      radius: 12,
      color: '#0F000000',
      offsetX: 0,
      offsetY: 4
    })
  }

  @Builder
  buildOrderItem(title: string, count: number, icon: Resource) {
    Column({ space: 10 }) {
      Stack() {
        Image(icon)
          .width(28)
          .height(28)

        if (count > 0) {
          Text(count.toString())
            .fontSize(10)
            .fontColor(Color.White)
            .padding({
              left: 6,
              right: 6,
              top: 1,
              bottom: 1
            })
            .borderRadius(10)
            .backgroundColor('#FF6B6B')
            .position({ x: 20, y: -6 })
        }
      }

      Text(title)
        .fontSize(13)
        .fontColor('#666666')
    }
    .padding({ top: 8, bottom: 8 })
    .width('25%')
    .onClick(() => this.handleOrderClick(title))
  }

  // ==================== 服务菜单区域 ====================
  @Builder
  buildServiceSection() {
    Column() {
      this.buildMenuItem($r('app.media.startIcon'), '我的优惠券', this.userInfo?.couponCount || 0)
      this.buildDivider()
      this.buildMenuItem($r('app.media.startIcon'), '我的收藏', this.collectCount)
      this.buildDivider()
      this.buildMenuItem($r('app.media.startIcon'), '收货地址', this.addressCount)
      this.buildDivider()
      this.buildMenuItem($r('app.media.servicer'), '服务中心', 0)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .margin({ left: 12, right: 12 })
    .borderRadius(20)
    .shadow({
      radius: 12,
      color: '#0F000000',
      offsetX: 0,
      offsetY: 4
    })
  }

  @Builder
  buildMenuItem(icon: Resource, text: string, count: number) {
    Row({ space: 16 }) {
      // 图标
      Stack() {
        Circle()
          .width(42)
          .height(42)
          .fill('#F5F7FA')

        Image(icon)
          .width(22)
          .height(22)
      }

      Text(text)
        .fontSize(16)
        .fontColor('#1A1A1A')
        .layoutWeight(1)

      // 数量角标
      if (count > 0) {
        Text(count.toString())
          .fontSize(12)
          .fontColor(Color.White)
          .padding({
            left: 8,
            right: 8,
            top: 3,
            bottom: 3
          })
          .backgroundColor('#FF6B6B')
          .borderRadius(12)
      }

      Image($r('app.media.right_arrow'))
        .width(18)
        .height(18)
        .fillColor('#CCCCCC')
    }
    .padding({
      left: 20,
      right: 20,
      top: 16,
      bottom: 16
    })
    .onClick(() => {
      console.log(`点击了: ${text}`)
      // 可在此处添加对应跳转逻辑
    })
  }

  @Builder
  buildDivider() {
    Divider()
      .strokeWidth(0.5)
      .color('#F0F0F0')
      .margin({ left: 78 }) // 对齐文字开始位置
  }

  // ==================== 退出登录按钮 ====================
  @Builder
  buildLogoutButton() {
    Button('退出登录')
      .width('90%')
      .height(50)
      .fontSize(17)
      .fontColor('#FF6B6B')
      .backgroundColor(Color.White)
      .border({ width: 1.5, color: '#FFE5E5' })
      .borderRadius(25)
      .margin({ top: 28, bottom: 32 })
      .shadow({
        radius: 6,
        color: '#1A000000',
        offsetX: 0,
        offsetY: 2
      })
      .onClick(async () => {
        try {
          await logout()
          this.userInfo = null
          this.collectCount = 0
          this.addressCount = 0
        } catch (error) {
          console.error('退出登录失败:', error)
        }
      })
  }

  // ==================== 工具方法 ====================
  private goToOrderList() {
    this.router.pushUrl({ url: 'pages/OrderListPage' })
      .catch((err:string) => console.error('跳转订单列表失败:', err))
  }

  private handleOrderClick(title: string) {
    const statusMap: Record<string, number> = {
      '待付款': 101,
      '待发货': 201,
      '待收货': 301,
      '待评价': 401  // 根据实际业务调整
    }

    this.router.pushUrl({
      url: 'pages/OrderListPage',
      params: { showType: statusMap[title] || 0 }
    }).catch((err:string) => console.error('跳转订单页面失败:', err))
  }

  build() {
    Column() {
      if (this.isLoading) {
        LoadingProgress()
          .width('100%')
          .height('100%')
          .color('#ff6bbfff')
      } else {
        // 顶部渐变用户信息栏
        this.buildUserInfo()

        // 内容区域
        Scroll() {
          Column({ space: 0 }) {
            this.buildOrderSection()
            this.buildServiceSection()

            if (this.userInfo) {
              this.buildLogoutButton()
            }
          }
          .width('100%')
          .padding({ bottom: 30 })
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)
        .margin({ top: -16 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}
