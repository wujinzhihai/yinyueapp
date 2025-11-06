import { Song } from '../models/Song'

/**
 * 歌曲列表项组件
 */
@Component
export struct SongListItem {
  @Prop song: Song
  onItemClick?: (song: Song) => void

  build() {
    Row() {
      // 封面图片（移除默认图片，使用占位符）
      Image(this.song.cover)
        .width(50)
        .height(50)
        .borderRadius(4)
        .margin({ right: 12 })
        .objectFit(ImageFit.Cover)
        .alt($r('sys.media.ohos_app_icon'))  // 使用系统默认图标
        .onError(() => {
          console.warn(`[SongListItem] 封面加载失败: ${this.song.cover}`)
        })

      // 歌曲信息
      Column() {
        Text(this.song.name)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(`${this.song.artist} - ${this.song.album}`)
          .fontSize(14)
          .fontColor('#999999')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .onClick(() => {
      if (this.onItemClick) {
        this.onItemClick(this.song)
      }
    })
  }
}
