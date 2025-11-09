import { router } from '@kit.ArkUI';
import { MusicItem } from '../models/MusicItem';

@Entry
@Component
struct PlayerPage {
  @State currentMusic: MusicItem | null = null;
  @State isPlaying: boolean = false;
  @State currentTime: number = 0;
  @State duration: number = 180; // 默认3分钟

  aboutToAppear(): void {
    // 接收路由参数
    const params = router.getParams() as Record<string, Object>;
    if (params && params['music']) {
      this.currentMusic = params['music'] as MusicItem;
      console.info('接收到歌曲数据:', JSON.stringify(this.currentMusic));
    }
  }

  // 返回上一页
  goBack(): void {
    router.back();
  }

  // 播放/暂停
  togglePlay(): void {
    this.isPlaying = !this.isPlaying;
    // TODO: 实现真实的音频播放控制
  }

  // 格式化时间
  formatTime(seconds: number): string {
    const min = Math.floor(seconds / 60);
    const sec = Math.floor(seconds % 60);
    return `${min}:${sec.toString().padStart(2, '0')}`;
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('sys.symbol.chevron_left'))
          .width(24)
          .height(24)
          .fillColor('#333333')
          .onClick(() => {
            this.goBack();
          })

        Text('正在播放')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        // 占位，保持标题居中
        Row().width(24).height(24)
      }
      .width('100%')
      .height(56)
      .padding({ left: 20, right: 20 })
      .justifyContent(FlexAlign.SpaceBetween)

      if (this.currentMusic) {
        Column() {
          // 封面
          Image(this.currentMusic.coverUrl)
            .width(280)
            .height(280)
            .borderRadius(20)
            .margin({ top: 60 })
            .shadow({ radius: 20, color: '#00000030', offsetX: 0, offsetY: 10 })

          // 歌曲信息
          Text(this.currentMusic.title)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
            .margin({ top: 40 })

          Text(this.currentMusic.artist)
            .fontSize(16)
            .fontColor('#666666')
            .margin({ top: 10 })

          // 进度条
          Column() {
            Slider({
              value: this.currentTime,
              min: 0,
              max: this.duration,
              step: 1,
              style: SliderStyle.OutSet
            })
              .blockColor('#1E90FF')
              .trackColor('#E0E0E0')
              .selectedColor('#1E90FF')
              .showSteps(false)
              .onChange((value: number) => {
                this.currentTime = value;
              })

            Row() {
              Text(this.formatTime(this.currentTime))
                .fontSize(12)
                .fontColor('#999999')

              Text(this.formatTime(this.duration))
                .fontSize(12)
                .fontColor('#999999')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ top: 5 })
          }
          .width('90%')
          .margin({ top: 40 })

          // 控制按钮
          Row() {
            // 上一曲
            Image($r('sys.symbol.backward_end_fill'))
              .width(40)
              .height(40)
              .fillColor('#666666')

            // 播放/暂停
            Image(this.isPlaying ? $r('sys.symbol.pause_circle_fill') : $r('sys.symbol.play_circle_fill'))
              .width(70)
              .height(70)
              .fillColor('#1E90FF')
              .margin({ left: 40, right: 40 })
              .onClick(() => {
                this.togglePlay();
              })

            // 下一曲
            Image($r('sys.symbol.forward_end_fill'))
              .width(40)
              .height(40)
              .fillColor('#666666')
          }
          .width('80%')
          .justifyContent(FlexAlign.Center)
          .margin({ top: 40 })
        }
        .width('100%')
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
      } else {
        // 无数据时显示提示
        Column() {
          Text('无歌曲信息')
            .fontSize(16)
            .fontColor('#999999')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
