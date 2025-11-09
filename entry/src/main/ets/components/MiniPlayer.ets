// entry/src/main/ets/components/MiniPlayer.ets

import { Song } from '../models/Song'
import { PlayerService } from '../services/PlayerService'
import { router } from '@kit.ArkUI'

@Component
export struct MiniPlayer {
  @StorageLink('currentSong') currentSong: Song | null = null
  @StorageLink('isPlaying') isPlaying: boolean = false
  private playerService: PlayerService = PlayerService.getInstance()

  build() {
    if (this.currentSong) {
      Row() {
        // 封面
        Image(this.currentSong.coverUrl || '')
          .width(50)
          .height(50)
          .borderRadius(4)
          .objectFit(ImageFit.Cover)
          .alt($r('app.media.app_icon'))

        // 歌曲信息
        Column() {
          Text(this.currentSong.name)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(this.currentSong.artist)
            .fontSize(12)
            .fontColor('#999999')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
        .margin({ left: 12 })

        // 播放/暂停按钮
        Button({ type: ButtonType.Circle }) {
          Text(this.isPlaying ? '⏸' : '▶')
            .fontSize(18)
            .fontColor(Color.White)
        }
        .width(40)
        .height(40)
        .backgroundColor('#FF6B6B')
        .onClick(() => {
          console.info(`[MiniPlayer] 点击播放按钮，当前状态: ${this.isPlaying}`)
          this.playerService.togglePlay()
        })

        // 播放列表按钮
        Button({ type: ButtonType.Circle }) {
          Text('📃')
            .fontSize(18)
        }
        .width(40)
        .height(40)
        .backgroundColor(Color.Transparent)
        .margin({ left: 8 })
      }
      .width('100%')
      .height(70)
      .padding({ left: 16, right: 16, top: 10, bottom: 10 })
      .backgroundColor(Color.White)
      .borderRadius({ topLeft: 12, topRight: 12 })
      .shadow({
        radius: 8,
        color: '#10000000',
        offsetY: -2
      })
      .onClick(() => {
        console.info('[MiniPlayer] 点击迷你播放器，跳转到播放页面')
        router.pushUrl({ url: 'pages/PlayerPage' })
      })
    }
  }
}
