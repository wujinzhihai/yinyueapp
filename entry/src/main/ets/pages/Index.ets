@Entry
@Component
struct Index {
  @State searchText: string = ''
  @State isPlaying: boolean = false
  @State currentSong: string = '暂无播放'
  @State currentArtist: string = ''
  @State progress: number = 0

  build() {
    Column() {
      // 顶部搜索栏
      Row() {
        TextInput({ placeholder: '搜索歌曲、歌手' })
          .width('85%')
          .height(40)
          .onChange((value: string) => {
            this.searchText = value
          })

        Button('搜索')
          .width('12%')
          .height(40)
          .onClick(() => {
            console.info(`搜索: ${this.searchText}`)
          })
      }
      .width('100%')
      .padding(10)
      .backgroundColor('#f5f5f5')

      // 主内容区域
      Column() {
        Text('音乐播放器')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 40, bottom: 20 })

        // 占位专辑封面
        Image($r('app.media.app_icon'))
          .width(200)
          .height(200)
          .borderRadius(10)
          .margin({ bottom: 30 })

        // 歌曲信息
        Text(this.currentSong)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 5 })

        Text(this.currentArtist)
          .fontSize(16)
          .fontColor('#666')
          .margin({ bottom: 10 })

        // 播放进度条
        Row() {
          Text('00:00')
            .fontSize(12)
            .fontColor('#999')

          Slider({
            value: this.progress,
            min: 0,
            max: 100,
            step: 1
          })
            .width('70%')
            .blockColor('#1890ff')
            .trackColor('#e0e0e0')
            .selectedColor('#1890ff')
            .onChange((value: number) => {
              this.progress = value
            })

          Text('00:00')
            .fontSize(12)
            .fontColor('#999')
        }
        .width('90%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ bottom: 40 })

        // 播放控制按钮
        Row() {
          Button('上一曲')
            .width(80)
            .height(40)
            .backgroundColor('#f0f0f0')
            .fontColor('#333')
            .onClick(() => {
              console.info('上一曲')
            })

          Button(this.isPlaying ? '暂停' : '播放')
            .width(80)
            .height(40)
            .backgroundColor('#1890ff')
            .fontColor('#fff')
            .onClick(() => {
              this.isPlaying = !this.isPlaying
              console.info(this.isPlaying ? '开始播放' : '暂停播放')
            })

          Button('下一曲')
            .width(80)
            .height(40)
            .backgroundColor('#f0f0f0')
            .fontColor('#333')
            .onClick(() => {
              console.info('下一曲')
            })
        }
        .width('90%')
        .justifyContent(FlexAlign.SpaceEvenly)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#fff')
    }
    .width('100%')
    .height('100%')
  }
}
