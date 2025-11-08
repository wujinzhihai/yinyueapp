import { Song } from '../models/Song'
import { PlayerService, PlayerState as PlayerServiceState } from '../services/PlayerService'

/**
 * 迷你播放器组件（底部栏）
 */
@Component
export struct MiniPlayer {
  @State private currentSong: Song | null = null
  @State private isPlaying: boolean = false

  private playerService: PlayerService | null = null

  aboutToAppear() {
    setTimeout(() => {
      this.initPlayerService()
    }, 500)
  }

  /**
   * 初始化播放器服务
   */
  private initPlayerService() {
    try {
      this.playerService = PlayerService.getInstance()

      if (this.playerService) {
        this.playerService.addListener({
          onSongChange: (song: Song | null) => {
            this.currentSong = song
          },
          onStateChange: (state: PlayerServiceState) => {
            this.isPlaying = (state === PlayerServiceState.PLAYING)
          }
        })
      }
    } catch (error) {
      console.warn('[MiniPlayer] PlayerService initialization failed:', error)
    }
  }

  /**
   * 播放/暂停切换
   */
  private async togglePlay() {
    if (!this.playerService) {
      try {
        this.playerService = PlayerService.getInstance()
      } catch (error) {
        console.error('[MiniPlayer] Cannot get player service:', error)
        return
      }
    }

    try {
      if (this.isPlaying) {
        await this.playerService.pause()
      } else if (this.currentSong) {
        await this.playerService.play()
      }
    } catch (error) {
      console.error('[MiniPlayer] Toggle play failed:', error)
    }
  }

  build() {
    Row() {
      if (this.currentSong) {
        // 左侧：歌曲信息
        Row() {
          // 封面图
          Image(this.currentSong.coverUrl || '')
            .width(50)
            .height(50)
            .borderRadius(6)
            .objectFit(ImageFit.Cover)
            .backgroundColor('#F0F0F0')

          Column() {
            // 歌曲名称
            Text(this.currentSong.name || '未知歌曲')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            // 歌手名称
            Text(this.currentSong.artist || '未知歌手')
              .fontSize(12)
              .fontColor('#999999')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 12 })
          .layoutWeight(1)
        }

        // 右侧：播放按钮
        Button(this.isPlaying ? '暂停' : '播放')
          .onClick(() => this.togglePlay())
          .fontSize(14)
          .padding({ left: 16, right: 16 })
      } else {
        // 无歌曲时的提示
        Text('暂无播放歌曲')
          .fontSize(14)
          .fontColor('#999999')
          .textAlign(TextAlign.Center)
          .layoutWeight(1)
      }
    }
    .width('100%')
    .height(60)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.White)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}
