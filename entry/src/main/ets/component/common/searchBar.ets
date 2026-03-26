import { Font, window } from '@kit.ArkUI'

@Component
export struct searchBar {
  build() {
    Column(){
      Search({placeholder:'搜索'}).placeholderFont({size:12}).fontColor('#ff2378b0').width('100%').height(30)
    }
    .width('100%').backgroundColor('#ffeeeeee')
  }
}