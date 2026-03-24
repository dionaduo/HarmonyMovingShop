import { getHomeData } from '../api/home';
import { window } from '@kit.ArkUI';
import { tabBarComponent } from '../component/common/tabBarComponent';
import { getCategory, getCurrentCategory, getSubCategoryDetail, getSubCategoryGoods } from '../api/category/catalog';
import { getGoodsDetail } from '../api/goods';
import { HomeBuilder } from '../component/home/HomeBuilder';
import { ChannelBar } from '../component/home/ChannelBar';
import { CouponBar } from '../component/home/CouponBar';
import { GrouponBar } from '../component/home/GrouponBar';
import { BrandBar } from '../component/home/BrandBar';
import { NewGoodsBar } from '../component/home/NewGoodsBar';
import { HotGoodsBar } from '../component/home/HotGoodsBar';


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

  @Builder
  homeBuilder() {
    Scroll(){
      Column(){
        HomeBuilder()
        ChannelBar()
        CouponBar()
        GrouponBar()
        BrandBar()
        NewGoodsBar()
        HotGoodsBar()
      }
    }
    .scrollBar(BarState.Off)
    .width('100%')
    .height('100%')
  }

  @Builder
  recommendBuilder() {
    Column() {
      Text('推荐页面内容')
    }.width('100%').height('100%')
  }

  @Builder
  favoriteBuilder() {
    Column() {
      Text('收藏页面内容')
    }.width('100%').height('100%')
  }

  @Builder
  moreBuilder() {
    Column() {
      Text('更多页面内容')
    }
    .width('100%').height('100%')
  }

  build() {
    Column() {
      tabBarComponent({
        homeContent: this.homeBuilder,
        recommendContent: this.recommendBuilder,
        favoriteContent: this.favoriteBuilder,
        moreContent: this.moreBuilder
      })
        .onClick(async ()=>{
          const res = await getHomeData()
          console.log(JSON.stringify(res.data.banner))
          //分类的数据
          // const res = await getCategory();
          // console.log(JSON.stringify(res.data.currentCategory))
          // console.log(JSON.stringify(res.data.categoryList))
          // const rescurr = await getCurrentCategory(1005000)
          // console.log(JSON.stringify(rescurr.data.currentSubCategory));
          // console.log(JSON.stringify(rescurr.data.currentCategory));
          // const res = await getSubCategoryDetail(1005000)
          // console.log(JSON.stringify(res.data.brotherCategory));
          // console.log(JSON.stringify(res.data.currentCategory));
          // console.log(JSON.stringify(res.data.parentCategory));
          // const re = await getSubCategoryGoods({ categoryId:1005000,page:1,limit:10 })
          // console.log(JSON.stringify(re.data.list));
          // console.log(JSON.stringify(re.data.filterCategoryList));
          // console.log(JSON.stringify(re.data.total));
          //
          //商品详细的数据
          // const goodsData = await getGoodsDetail(1181000)
          // console.log(JSON.stringify(goodsData.data))
        })
    }
    .height('100%')
    .width('100%')
  }
}