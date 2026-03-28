import { httpRequest } from '../utils/request'
import { PageList } from '../viewModel/category/catalog'
import { ApiResponse } from '../viewModel'
import { Topic } from '../viewModel/home/IHomeData'
import { goods } from '../component/goods/goods'
import { router } from '@kit.ArkUI'

export const getTopicList = (page: number = 1, limit: number = 10): Promise<ApiResponse<PageList<Topic>>> => {
  return httpRequest.get('topic/list', { params: { page, limit } })
}

@Entry
@Component
export struct TopicPage {
  @State topicList: Topic[] = []
  @State page: number = 1
  @State limit: number = 10
  @State totalPages: number = 1
  @State loading: boolean = false
  @State refreshing: boolean = false
  private router = this.getUIContext().getRouter()
  private prompt = this.getUIContext().getPromptAction()

  aboutToAppear(): void {
    this.loadTopicList()
  }

  private async loadTopicList(refresh: boolean = false): Promise<void> {
    if (this.loading) return

    this.loading = true
    if (refresh) {
      this.refreshing = true
      this.page = 1
    }

    try {
      const res: ApiResponse<PageList<Topic>> = await getTopicList(this.page, this.limit)
      if (res.errno === 0 && res.data) {
        this.totalPages = res.data.pages || 1
        if (refresh) {
          this.topicList = res.data.list || []
        } else {
          this.topicList = [...this.topicList, ...(res.data.list || [])]
        }
      } else {
        this.prompt.showToast({ message: res.errmsg || '加载失败' })
      }
    } catch (error) {
      console.error('加载专题列表失败', error)
      this.prompt.showToast({ message: '网络请求失败' })
    } finally {
      this.loading = false
      this.refreshing = false
    }
  }

  private handleRefresh(): void {
    this.loadTopicList(true)
  }

  private handleLoadMore(): void {
    if (this.page < this.totalPages) {
      this.page++
      this.loadTopicList()
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
        Text('更多专题')
          .fontSize(18)
          .fontColor('#333333')
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)

      if (this.topicList.length === 0 && !this.loading) {
        Column() {
          Image($r('sys.media.ohos_ic_public_email'))
            .width(120)
            .height(120)
            .fillColor('#cccccc')
          Text('暂无专题')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ top: 12 })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          Column() {
            ForEach(this.topicList, (item: Topic) => {
              goods({
                goodTitle: item.title,
                goodsImage: item.picUrl,
                goodsDesc: item.subtitle,
              })
                .onClick(() => {
                  this.router.pushUrl({
                    url: 'view/home/TopicDetailPage',
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
    .padding({ top: 30 })
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}
