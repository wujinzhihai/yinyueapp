import { Song } from '../models/Song'

/**
 * 歌曲列表项组件
 */
@Component
export struct SongListItem {
  // ✅ 使用普通参数而不是@Prop
  song: Song = new Song(0, '', '', '', '', 0)
  onItemClick?: (song: Song) => void

  build() {
    Row() {
      // 封面图
      Image(this.song.coverUrl)
        .width(60)
        .height(60)
        .borderRadius(8)
        .margin({ right: 12 })
        .objectFit(ImageFit.Cover)

      // 歌曲信息
      Column() {
        Text(this.song.name)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
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
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ bottom: 8 })
    .onClick(() => {
      if (this.onItemClick) {
        this.onItemClick(this.song)
      }
    })
  }
}
