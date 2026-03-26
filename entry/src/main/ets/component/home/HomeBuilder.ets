import { getHomeData } from "../../api/home"
import { Banner } from "../../viewModel/home/IHomeData"
import { searchBar } from "../common/searchBar"
import { window } from "@kit.ArkUI"
import { loadData } from "../../api"

@Component
export struct HomeBuilder {
  @State bannerImage:Array<Banner> = []

  async aboutToAppear(): Promise<void> {
    this.bannerImage = await loadData(this.bannerImage, 'banner');
  }

  build() {
    Column(){
      Row(){
        searchBar()
      }.width('100%').height('6%')
      Scroll(){
        Row() {
          Swiper(){
            ForEach(this.bannerImage, (item:Banner, index) => {
                Image(item.url).width('100%').height('150').objectFit(ImageFit.Contain)
            })
          }
          .loop(true)
          .autoPlay(true)
          .interval(1000)
          .height(200)
          .width('100%')
        }.justifyContent(FlexAlign.Center).width('100%')
      }
    }.width('100%').padding({top:30, left: 10, right: 10 })

  }
}
