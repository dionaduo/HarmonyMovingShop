import { getHomeData } from "../../api/home"
import { Banner } from "../../viewModel/home/IHomeData"

@Component
export struct HomeBuilder {
  @State bannerImage:Array<Banner> = []

  aboutToAppear(): void {
    this.getBannerImage()
  }
  private async getBannerImage(){
    try {
      const res = await getHomeData()
      this.bannerImage = res.data.banner
      console.log(JSON.stringify(this.bannerImage))
    } catch (err) {
      console.error(err)
    }
  }

  build() {
    Column(){
      Row(){
        Search()
      }.width('100%').height('10%').backgroundColor(Color.Orange)
      Scroll(){
        Row() {
          Text('Home').fontSize(30).fontColor('#ff000000')
          List(){
            ForEach(this.bannerImage, (item:Resource, index) => {
              ListItem(){
                Image(item).width('100%').height('150').objectFit(ImageFit.Contain)
              }
            })
          }
          .scrollBar(BarState.Off)
          .height(200)
          .width('100%')
          .padding({ left: 15, right: 15 })
          .listDirection(Axis.Horizontal)
        }.justifyContent(FlexAlign.Center).width('100%')
      }
    }.width('100%').width('100%').backgroundColor('#ffe2e2de')
  }
}
