import { it } from '@ohos/hypium'
import { loadData } from '../../api';
import { getHomeData } from '../../api/home'
import { Category } from '../../viewModel/category/catalog';
import { Channel } from '../../viewModel/home/IHomeData'

@Component
export struct ChannelBar {
  @State channelImage:  Array<Channel> = []

  private router = this.getUIContext().getRouter()

  async aboutToAppear(): Promise<void> {
    this.channelImage = await loadData(this.channelImage, 'channel');
  }

  build() {
    Column(){
      Grid(){
        ForEach(this.channelImage,(item:Channel,index:number)=>{
          GridItem(){
            Column(){
              Image(item.iconUrl).width(30).height(30)
              Text(item.name).fontSize(12).fontFamily('PingFang SC').textAlign(TextAlign.Center)
            }.onClick(()=>{
              this.router.pushUrl({
                url: 'view/category/subCategory',
                params: {
                  id: item.id
                }as Category
              })
            })
          }
        })
      }.width('100%')
      .height(100)
      .rowsTemplate('repeat(2, 1fr)')
      .columnsTemplate('repeat(5, 1fr)')
    }.width('100%').padding({ left: 10, right: 10 })
  }
}