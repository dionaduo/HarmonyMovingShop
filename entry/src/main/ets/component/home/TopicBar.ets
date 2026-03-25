import { Topic } from "../../viewModel/home/IHomeData"
import { header } from "../common/header"
import { window } from "@kit.ArkUI"
import { getHomeData } from "../../api/home"
import { loadData } from "../../api"

@Component
export struct TopicBar {
  @State topic: Array<Topic> = []

  async aboutToAppear(): Promise<void> {
    this.topic = await loadData(this.topic, 'topicList');
    window.getLastWindow(this.getUIContext().getHostContext()).then((win) => {
      win.setWindowLayoutFullScreen(true).catch((err: string) => {
        console.log(err)
      })
    })
  }
  build() {
    Column(){
      header({
        head:'专题',
        moreHead:'更多专题'
      })
      Row(){
        Grid(){
          ForEach(this.topic, (item:Topic, index) => {
            GridItem(){
              Column({space:2}) {
                Image(item.picUrl)
                  .width(150)
                  .height(120)
                  .objectFit(ImageFit.Contain)
                Text(item.title)
                  .fontSize(12)
                  .fontColor(Color.Black)
                  .textAlign(TextAlign.Center)
                Text(item.subtitle)
                  .fontSize(10)
                  .fontColor(Color.Gray)
                  .textAlign(TextAlign.Center)
              }.width('100%').padding(3)
            }
          })
        }.rowsTemplate('repeat(2,1fr)')
        .columnsTemplate('repeat(2,1fr)')
        .height(330)
        .padding(3)
        .columnsGap(2)
        .rowsGap(3)
      }
    }.padding(10).width('100%')
  }
}