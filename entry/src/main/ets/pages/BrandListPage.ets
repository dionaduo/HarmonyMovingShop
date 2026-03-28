import { httpRequest } from '../utils/request'
import { PageList } from '../viewModel/category/catalog'
import { ApiResponse } from '../viewModel'
import { Brand } from '../viewModel/home/IHomeData'
import { goods } from '../component/goods/goods'
import { router } from '@kit.ArkUI'

export const getBrandList = (page: number = 1, limit: number = 10): Promise<ApiResponse<PageList<Brand>>> => {
  return httpRequest.get('brand/list', { params: { page, limit } })
}

@Entry
@Component
export struct BrandListPage {
  @State brandList: Brand[] = []
  @State page: number = 1
  @State limit: number = 10
  @State totalPages: number = 1
  @State loading: boolean = false
  @State refreshing: boolean = false
  private router = this.getUIContext().getRouter()
  private prompt = this.getUIContext().getPromptAction()

  aboutToAppear(): void {
    this.loadBrandList()
  }

  private async loadBrandList(refresh: boolean = false): Promise<void> {
    if (this.loading) return

    this.loading = true
    if (refresh) {
      this.refreshing = true
      this.page = 1
    }

    try {
      const res: ApiResponse<PageList<Brand>> = await getBrandList(this.page, this.limit)
      if (res.errno === 0 && res.data) {
        this.totalPages = res.data.pages || 1
        if (refresh) {
          this.brandList = res.data.list || []
        } else {
          this.brandList = [...this.brandList, ...(res.data.list || [])]
        }
      } else {
        this.prompt.showToast({ message: res.errmsg || '加载失败' })
      }
    } catch (error) {
      console.error('加载品牌列表失败', error)
      this.prompt.showToast({ message: '网络请求失败' })
    } finally {
      this.loading = false
      this.refreshing = false
    }
  }

  private handleRefresh(): void {
    this.loadBrandList(true)
  }

  private handleLoadMore(): void {
    if (this.page < this.totalPages) {
      this.page++
      this.loadBrandList()
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.right_arrow'))
          .width(24)
          .height(24)
          .onClick(() => {
            this.router.back()
          })
        Text('更多品牌商')
          .fontSize(18)
          .fontColor('#333333')
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)

      if (this.brandList.length === 0 && !this.loading) {
        Column() {
          Image($r('sys.media.ohos_ic_public_email'))
            .width(120)
            .height(120)
            .fillColor('#cccccc')
          Text('暂无品牌')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ top: 12 })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          Column() {
            ForEach(this.brandList, (item: Brand) => {
              goods({
                goodTitle: item.name,
                goodsImage: item.picUrl,
                goodsDesc: item.desc,
                goodsRealPrice: `¥${item.floorPrice}起`,
                goodsCurPrice: ''
              })
                .onClick(() => {
                  this.router.pushUrl({
                    url: 'view/goods/BrandDetailPage',
                    params: { id: item.id }
                  })
                })
            })
          }
          .padding(12)
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)
        .onReachEnd(() => {
          this.handleLoadMore()
        })
      }
    }
    .justifyContent(FlexAlign.Start)
    .padding({top:30})
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}
