import { Song } from '../models/Song'
import { getPlayerState } from '../store/PlayerState'
import { PlayerService, PlayerState } from '../services/PlayerService'

/**
 * 迷你播放器组件（底部栏）
 */
@Component
export struct MiniPlayer {
  @State private currentSong: Song | null = null
  @State private isPlaying: boolean = false
  @State private currentTime: number = 0
  @State private duration: number = 0
  // ✅ 修复1：使用 getInstance() 而不是 new
  private playerService: PlayerService = PlayerService.getInstance()

  aboutToAppear() {
    // 初始化状态
    this.syncPlayerState()

    // 每500ms同步一次状态
    setInterval(() => {
      this.syncPlayerState()
    }, 500)

    // ✅ 新增：监听播放器事件（更准确的状态同步）
    this.playerService.addListener({
      onStateChange: (state: PlayerState) => {
        this.isPlaying = (state === PlayerState.PLAYING)
      },
      onSongChange: (song: Song | null) => {
        this.currentSong = song
      },
      onProgressChange: (current: number, duration: number) => {
        this.currentTime = Math.floor(current / 1000) // ms -> s
        this.duration = Math.floor(duration / 1000)   // ms -> s
      }
    })
  }

  /**
   * 同步播放器状态
   */
  private syncPlayerState() {
    const state = getPlayerState()
    this.currentSong = state.currentSong
    this.isPlaying = state.isPlaying
    this.currentTime = state.currentTime
    this.duration = state.duration
  }

  /**
   * 播放/暂停切换
   */
  private togglePlay() {
    if (this.isPlaying) {
      this.playerService.pause()
    } else {
      // ✅ 修复2：resume() 改为 play()
      this.playerService.play()
    }
  }

  /**
   * 格式化时间（秒 -> mm:ss）
   */
  private formatTime(seconds: number): string {
    const min = Math.floor(seconds / 60)
    const sec = Math.floor(seconds % 60)
    return `${min.toString().padStart(2, '0')}:${sec.toString().padStart(2, '0')}`
  }

  build() {
    if (this.currentSong === null) {
      // 没有歌曲时不显示
      Row().height(0)
    } else {
      Column() {
        // 进度条
        Progress({
          value: this.currentTime,
          total: this.duration,
          type: ProgressType.Linear
        })
          .width('100%')
          .height(2)
          .color('#FF6B6B')
          .backgroundColor('#F0F0F0')

        // 播放器主体
        Row() {
          // 左侧：封面 + 歌曲信息
          Row() {
            Image(this.currentSong.coverUrl)
              .width(50)
              .height(50)
              .borderRadius(6)
              .objectFit(ImageFit.Cover)

            Column() {
              Text(this.currentSong.name)
                .fontSize(15)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })

              Text(this.currentSong.artist)
                .fontSize(13)
                .fontColor('#999999')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ top: 2 })
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ left: 12 })
            .layoutWeight(1)
          }
          .layoutWeight(1)

          // 右侧：播放控制按钮
          Row() {
            // 时间显示
            Text(`${this.formatTime(this.currentTime)} / ${this.formatTime(this.duration)}`)
              .fontSize(12)
              .fontColor('#666666')
              .margin({ right: 16 })

            // 播放/暂停按钮（使用文本符号）
            Button(this.isPlaying ? '⏸' : '▶')
              .width(40)
              .height(40)
              .fontSize(20)
              .backgroundColor('#FF6B6B')
              .fontColor(Color.White)
              .onClick(() => {
                this.togglePlay()
              })

            // 下一曲按钮（使用文本符号）
            Button('⏭')
              .width(40)
              .height(40)
              .fontSize(18)
              .backgroundColor('#E0E0E0')
              .fontColor('#666666')
              .margin({ left: 12 })
              .onClick(() => {
                // ✅ 修复3：next() 改为 playNext()
                this.playerService.playNext()
              })
          }
        }
        .width('100%')
        .height(70)
        .padding({ left: 16, right: 16 })
        .backgroundColor(Color.White)
      }
      .width('100%')
      .shadow({
        radius: 8,
        color: 'rgba(0, 0, 0, 0.08)',
        offsetY: -2
      })
    }
  }
}
