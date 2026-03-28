import { httpRequest } from '../../utils/request'
import { ApiResponse } from '../../viewModel'
import { GoodsItem } from '../../viewModel/goods/goods'
import { goods } from '../../component/goods/goods'

interface TopicDetail {
  id: number;
  title: string;
  subtitle: string;
  price: number;
  readCount: string;
  picUrl: string;
  sortOrder: number;
  goods: GoodsItem[];
  addTime: string;
  updateTime: string;
  deleted: boolean;
  content: string;
}

interface TopicDetailData {
  userHasCollect: number;
  topic: TopicDetail;
  goods: GoodsItem[];
}

export const getTopicDetail = (id: number): Promise<ApiResponse<TopicDetailData>> => {
  return httpRequest.get('topic/detail', { params: { id } })
}

@Entry
@Component
export struct TopicDetailPage {
  @State topicDetail: TopicDetailData | null = null
  @State detailImageUrls: string[] = []
  @State loading: boolean = true
  private router = this.getUIContext().getRouter()
  private prompt = this.getUIContext().getPromptAction()

  aboutToAppear(): void {
    const params = this.router.getParams() as Record<string, Object>
    const id = params?.id as number
    if (id) {
      this.loadTopicDetail(id)
    }
  }

  private parseDetailImages(): void {
    if (!this.topicDetail?.topic?.content) {
      this.detailImageUrls = []
      return
    }
    const html: string = this.topicDetail.topic.content
    const urls: string[] = []
    const imgRegex = /<img[^>]+src=["']?([^"'\s>]+)["']?[^>]*>/gi
    let match: RegExpExecArray | null

    while ((match = imgRegex.exec(html)) !== null) {
      let url = match[1].trim()
      if (url.startsWith('//')) {
        url = 'https:' + url
      }
      if (url.startsWith('http://') || url.startsWith('https://')) {
        urls.push(url)
      }
    }
    this.detailImageUrls = urls
  }

  private async loadTopicDetail(id: number): Promise<void> {
    this.loading = true
    try {
      const res: ApiResponse<TopicDetailData> = await getTopicDetail(id)
      console.log('专题详情:', JSON.stringify(res))
      if (res.errno === 0 && res.data) {
        this.topicDetail = res.data
        this.parseDetailImages()
      } else {
        this.prompt.showToast({ message: res.errmsg || '获取专题详情失败' })
      }
    } catch (error) {
      console.error('获取专题详情失败', error)
      this.prompt.showToast({ message: '获取专题详情失败' })
    } finally {
      this.loading = false
    }
  }

  build() {
    Column() {
      if (this.loading) {
        Column() {
          LoadingProgress()
            .width(48)
            .height(48)
            .color('#ff6bbfff')
          Text('加载中...')
            .fontSize(16)
            .fontColor('#999999')
            .margin({ top: 12 })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else if (this.topicDetail) {
        Column(){
          Row() {
            Image($r('app.media.right_arrow')).width(16)
            Text('返回').fontSize(16).fontColor('#333333')
          }
          .justifyContent(FlexAlign.Start)
          .width(40).height(30).onClick(() => {
            this.router.back()
          })

          Blank().backgroundColor(Color.Transparent)
          Scroll() {
            Column() {
              // 专题封面
              Image(this.topicDetail.topic.picUrl)
                .width('100%')
                .height(240)
                .objectFit(ImageFit.Cover)

              // 专题标题
              Text(this.topicDetail.topic.title)
                .fontSize(20)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
                .width('100%')
                .textAlign(TextAlign.Center)
                .padding({ top: 16 })

              // 专题副标题
              Text(this.topicDetail.topic.subtitle)
                .fontSize(14)
                .fontColor('#999999')
                .width('100%')
                .textAlign(TextAlign.Center)
                .padding({ top: 8 })

              // 阅读数
              Row() {
                Text(`阅读 ${this.topicDetail.topic.readCount}`)
                  .fontSize(12)
                  .fontColor('#999999')
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .padding({ top: 8 })

              // 专题内容图片
              Column() {
                ForEach(this.detailImageUrls, (url: string) => {
                  Image(url)
                    .width('100%')
                    .objectFit(ImageFit.Contain)
                })
              }
              .width('100%')
              .padding({ top: 16 })

              // 推荐商品标题
              Text('专题商品')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
                .width('100%')
                .textAlign(TextAlign.Start)
                .padding({ top: 24, bottom: 12, left: 12 })

              // 专题商品列表
              Column() {
                ForEach(this.topicDetail.goods, (item: GoodsItem) => {
                  goods({
                    goodTitle: item.name,
                    goodsImage: item.picUrl,
                    goodsDesc: item.brief,
                    goodsRealPrice: item.retailPrice,
                    goodsCurPrice: item.counterPrice
                  })
                    .onClick(() => {
                      this.router.pushUrl({
                        url: 'view/goods/GoodsDetailPage',
                        params: { id: item.id } as GoodsItem
                      }).catch((err: string) => {
                        console.log('跳转失败,错误信息:' + err)
                      })
                    })
                })
              }
              .width('100%')
              .padding(12)
              .backgroundColor(Color.White)
            }
          }
          .scrollBar(BarState.Off)
          .layoutWeight(1)
        }.padding({top:30})

      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}
