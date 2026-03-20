import { getHomeData } from '../api/home';
import { window } from '@kit.ArkUI';

interface ITitle { title: string;color: Color; }

@Entry
@Component
struct Index {
  aboutToAppear(): void {
    window.getLastWindow(this.getUIContext().getHostContext()).then((win)=>{
      win.setWindowLayoutFullScreen(true).catch((err:string)=>{
        console.log(err)
      })
    })
  }

  @State curTabIndex:number = 0
  @State currTabImage:Resource[] =[
    $r('app.media.MF'),
    $r('app.media.MU'),
    $r('app.media.MC'),
    $r('app.media.MK'),
    $r('app.media.wxts')
  ]
  @State titleList: ITitle[] = [
    {title:'精选',color:Color.Red},
    {title:'推荐',color:Color.Blue},
    {title:'收藏',color:Color.Green},
    {title:'更多',color:Color.Orange}
  ]
  @Builder tabItem(index:number,title:string,icon:Resource,selectedIcon: Resource){
    Column(){
      Image(index == this.curTabIndex ? selectedIcon : icon).width(20)
      Divider().width(35).strokeWidth(3).margin({ top: 3, bottom: 3 }).backgroundColor(index == this.curTabIndex ? Color.Red : Color.Transparent)
      Text(title).fontSize(16).fontColor(index == this.curTabIndex ? Color.Red : Color.Black).padding({bottom:30})
    }
  }

  build() {
    Column(){
      Tabs(){
        ForEach(this.titleList,(item:ITitle, index:number) => {
          TabContent() {
            Text(item.title).fontSize(22).fontColor(item.color)
          }.tabBar(this.tabItem(index, item.title, this.currTabImage[index], this.currTabImage[4]))
        })

      }.scrollable(false).barPosition(BarPosition.End)
      .onChange((index:number)=>{
        this.curTabIndex = index
      })
    }
    .height('100%')
    .width('100%')
  }
}