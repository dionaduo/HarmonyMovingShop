// searchBar.ets
import { CategoryL1, PageList } from '../../viewModel/category/catalog'
import { GoodsItem } from '../../viewModel/goods/goods'

@Component
export struct searchBar {
  // 搜索输入内容
  @State searchValue: string = ''
  // 搜索结果页面路径（根据你的项目路由配置调整）
  private router = this.getUIContext().getRouter()

  // 执行搜索
  private handleSearch(): void {
    const keyword = this.searchValue.trim()
    if (!keyword) {
      return
    }

    console.log(`执行搜索: ${keyword}`)

    // 跳转到搜索结果页，携带 keyword 参数（类似 Vue 的 router.push query）
    this.router.pushUrl({
      url: 'view/home/searchResult',
      params: {
        keyword: keyword
      }
    }).catch((err:string) => {
      console.error('跳转搜索结果页失败:', err)
    })
  }

  build() {
    Column() {
      Search({
        value: this.searchValue,
        placeholder: '搜搜你喜欢的商品...',
      })
        .onChange((value: string) => {
          this.searchValue = value
        })
        .onSubmit(() => {
          this.handleSearch()
        })

        .width('100%')
        .height(30)
        .backgroundColor(Color.White)
        .placeholderFont({ size: 15 })
        .fontColor(Color.Black)
        .padding({ left: 12, right: 12 })

      // 可选：添加搜索按钮（类似 Vue 的 show-action）
      Row() {
        Button('搜索')
          .fontSize(16)
          .fontColor('#1989fa')
          .backgroundColor('transparent')
          .onClick(() => {
            this.handleSearch()
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.End)
      .padding({ right: 12 })
    }
    .width('100%')
    .backgroundColor('#f8f8f8')
  }
}