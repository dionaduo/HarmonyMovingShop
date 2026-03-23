import { it } from '@ohos/hypium'
import { getHomeData } from '../../api/home'
import { Channel } from '../../viewModel/home/IHomeData'

@Component
export struct ChannelBar {
  @State channelImage:  Array<Channel> = []

  aboutToAppear(): void {
    this.getChannelImage()
  }

  private async getChannelImage() {
    try {
      const res = await getHomeData()
      this.channelImage = res.data.channel
      console.log(JSON.stringify(this.channelImage))
    } catch (err) {
      console.error(err)
    }
  }

  build() {
    Column(){
      Grid(){
        ForEach(this.channelImage,(item:Channel,index:number)=>{
          GridItem(){
            Column(){
              Image(item.iconUrl).width(30).height(30)
              Text(item.name).fontSize(12).fontFamily('PingFang SC').textAlign(TextAlign.Center)
            }
          }
        })
      }.width('100%')
      .height(100)
      .rowsTemplate('repeat(2, 1fr)')
      .columnsTemplate('repeat(5, 1fr)')
    }.width('100%').backgroundColor('#ffe2e2de').padding({ left: 10, right: 10 })
  }
}