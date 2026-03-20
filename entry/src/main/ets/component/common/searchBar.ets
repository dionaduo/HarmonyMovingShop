import { window } from '@kit.ArkUI'

@Entry
@Component
struct searchBar {
  aboutToAppear(): void {
    window.getLastWindow(this.getUIContext().getHostContext()).then((win) => {
      win.setWindowLayoutFullScreen(true).catch((err: string) => {
        console.log(err)
      })
    })
  }
  build() {
    Column(){
      Search().width('80%').height(40).backgroundColor(Color.Gray)
    }.width('100%')
  }
}