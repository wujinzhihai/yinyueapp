// entry/src/main/ets/components/MiniPlayer.ets

import { PlayerService } from '../services/PlayerService'

@Component
export struct MiniPlayer {
  private playerService: PlayerService = PlayerService.getInstance()
  @State refreshKey: number = 0
  private refreshTimer: number = -1

  aboutToAppear(): void {
    // ✅ 启动定时刷新
    this.refreshTimer = setInterval(() => {
      this.refreshKey++
    }, 500)
  }

  aboutToDisappear(): void {
    clearInterval(this.refreshTimer)
  }

  build() {
    Column() {
      Row() {
        Slider({
          value: this.playerService.currentTime,
          min: 0,
          max: this.playerService.duration > 0 ? this.playerService.duration : 100,
          step: 1000
        })
          .width('100%')
          .trackColor('#E0E0E0')
          .selectedColor('#FF1744')
          .blockColor('#FF1744')
          .trackThickness(2)
          .onChange((value: number) => {
            this.playerService.seekTo(value)
          })
      }
      .width('100%')
      .height(20)
      .key(`slider-${this.refreshKey}`)  // ✅ 强制刷新

      Row() {
        Column() {
          Text(this.playerService.currentSong?.name || '暂无播放')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333333')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(this.playerService.currentSong?.artist || '')
            .fontSize(12)
            .fontColor('#999999')
            .margin({ top: 2 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        Row({ space: 20 }) {
          Text('⏮')
            .fontSize(24)
            .fontColor('#333333')
            .onClick(() => {
              this.playerService.playPrevious()
            })

          Text(this.playerService.isPlaying ? '⏸' : '▶')
            .fontSize(28)
            .fontColor('#FF1744')
            .onClick(() => {
              this.playerService.togglePlay()
            })

          Text('⏭')
            .fontSize(24)
            .fontColor('#333333')
            .onClick(() => {
              this.playerService.playNext()
            })
        }

        Text(`${this.formatTime(this.playerService.currentTime)} / ${this.formatTime(this.playerService.duration)}`)
          .fontSize(12)
          .fontColor('#999999')
          .margin({ left: 15 })
      }
      .width('100%')
      .padding({ left: 15, right: 15, bottom: 10 })
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius({ topLeft: 16, topRight: 16 })
    .shadow({
      radius: 10,
      color: '#00000020',
      offsetY: -2
    })
  }

  private formatTime(ms: number): string {
    const seconds = Math.floor(ms / 1000)
    const mins = Math.floor(seconds / 60)
    const secs = seconds % 60
    return `${mins}:${secs.toString().padStart(2, '0')}`
  }
}
