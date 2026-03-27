import { window } from '@kit.ArkUI';
import { tabBarComponent } from '../component/common/tabBarComponent';
import { HomeBuilder } from '../component/home/HomeBuilder';
import { ChannelBar } from '../component/home/ChannelBar';
import { CouponBar } from '../component/home/CouponBar';
import { GrouponBar } from '../component/home/GrouponBar';
import { BrandBar } from '../component/home/BrandBar';
import { NewGoodsBar } from '../component/home/NewGoodsBar';
import { HotGoodsBar } from '../component/home/HotGoodsBar';
import { TopicBar } from '../component/home/TopicBar';
import { categoryBar } from '../component/category/categoryBar';
import { GoodsCart } from '../view/cart/GoodsCart';
import { mine } from '../view/mine/mine';
import PreferencesUtil from '../utils/PreferencesUtil';

@Entry
@Component
struct Index {
  private router = this.getUIContext().getRouter()

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
        TopicBar()
      }
    }
    .scrollBar(BarState.Off)
    .width('100%')
    .height('100%')
  }
  @Builder
  categoryBuilder() {
    categoryBar()
  }
  @Builder
  favoriteBuilder() {
    Column() {
      GoodsCart()
    }.width('100%').height('100%')
  }
  @Builder
  moreBuilder() {
    Column() {
      mine()
    }
    .width('100%').height('100%')
  }

  @State currentTabIndex: number = 0;

  /**
   * 检查登录状态并跳转
   * @param targetIndex 目标Tab索引 (例如: 购物车是2, 我的 是3)
   * @param targetUrl 如果不是Tab跳转，而是普通页面跳转，则传入URL
   */
  async checkLoginAndNavigate(targetIndex: number, targetUrl?: string) {
    const token = await PreferencesUtil.getToken();

    if (token) {
      // 已登录，正常执行
      if (targetUrl) {
        this.router.pushUrl({ url: targetUrl });
      } else {
        this.currentTabIndex = targetIndex;
      }
    } else {
      // 未登录，跳转到登录页
      // 传递一个回调参数，或者登录成功后自动返回的逻辑
      this.router.pushUrl({
        url: 'view/login/LoginPage'
      });
    }
  }

  /**
   * 处理 Tab 切换事件 - 返回 true 允许切换，false 阻止切换
   */
  async handleTabChange(index: number): Promise<boolean> {
    if (index === 2 || index === 3) { // 购物车(2) 或 我的(3)
      const token = await PreferencesUtil.getToken();
      if (!token) {
        // 未登录，跳转到登录页，并阻止切换
        this.router.pushUrl({
          url: 'view/login/LoginPage'
        });
        return false;
      }
    }
    // 允许切换
    return true;
  }

  build() {
    Column() {
      tabBarComponent({
        curTabIndex: $currentTabIndex,
        homeContent: this.homeBuilder,
        recommendContent: this.categoryBuilder,
        favoriteContent: this.favoriteBuilder,
        moreContent: this.moreBuilder,
        onTabChange: this.handleTabChange.bind(this)
      })
    }
    .height('100%')
    .width('100%')
  }
}
