import { MusicItem } from '../models/MusicItem';
import MusicApiService from '../services/MusicApiService';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State musicList: MusicItem[] = [];
  @State isLoading: boolean = false;
  @State isSearching: boolean = false;
  @State searchKeyword: string = '';

  aboutToAppear(): void {
    this.loadMusicList();
  }

  // 加载音乐列表
  async loadMusicList(): Promise<void> {
    this.isLoading = true;
    try {
      this.musicList = await MusicApiService.fetchMusicList();
    } catch (error) {
      console.error('加载音乐列表失败:', error);
    } finally {
      this.isLoading = false;
    }
  }

  // 搜索音乐
  async handleSearch(): Promise<void> {
    // 清空原有列表
    this.musicList = [];
    this.isSearching = true;

    try {
      this.musicList = await MusicApiService.searchMusic(this.searchKeyword);
    } catch (error) {
      console.error('搜索失败:', error);
    } finally {
      this.isSearching = false;
    }
  }

  // 跳转到播放器页面
  navigateToPlayer(music: MusicItem): void {
    router.pushUrl({
      url: 'pages/PlayerPage',
      params: {
        music: music
      }
    }).catch((err: Error) => {
      console.error('页面跳转失败:', err);
    });
  }

  build() {
    Column() {
      // 顶部搜索栏
      Row() {
        TextInput({ placeholder: '搜索歌曲或歌手', text: this.searchKeyword })
          .width('70%')
          .height(40)
          .onChange((value: string) => {
            this.searchKeyword = value;
          })
          .onSubmit(() => {
            this.handleSearch();
          })

        Button('搜索')
          .width('25%')
          .height(40)
          .margin({ left: 10 })
          .onClick(() => {
            this.handleSearch();
          })
      }
      .width('90%')
      .margin({ top: 20, bottom: 20 })

      // 音乐列表
      if (this.isLoading || this.isSearching) {
        Column() {
          LoadingProgress()
            .width(50)
            .height(50)
            .margin({ top: 100 })

          Text(this.isSearching ? '正在搜索...' : '加载中...')
            .fontSize(16)
            .fontColor('#999999')
            .margin({ top: 20 })
        }
        .width('100%')
        .height('80%')
        .justifyContent(FlexAlign.Center)
      } else if (this.musicList.length === 0) {
        Column() {
          Text('未找到相关歌曲')
            .fontSize(16)
            .fontColor('#999999')
        }
        .width('100%')
        .height('80%')
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 10 }) {
          ForEach(this.musicList, (item: MusicItem) => {
            ListItem() {
              MusicItemComponent({
                music: item,
                onItemClick: (music: MusicItem) => {
                  this.navigateToPlayer(music);
                }
              })
            }
          }, (item: MusicItem) => item.id)
        }
        .width('100%')
        .height('80%')
        .padding({ left: 20, right: 20 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}

@Component
struct MusicItemComponent {
  @Prop music: MusicItem;
  onItemClick?: (music: MusicItem) => void;

  build() {
    Row() {
      Image(this.music.coverUrl)
        .width(60)
        .height(60)
        .borderRadius(8)
        .objectFit(ImageFit.Cover)

      Column() {
        Text(this.music.title)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')

        Text(this.music.artist)
          .fontSize(14)
          .fontColor('#666666')
          .margin({ top: 5 })
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 15 })
      .layoutWeight(1)

      Image($r('sys.symbol.play_circle'))
        .width(30)
        .height(30)
        .fillColor('#1E90FF')
    }
    .width('100%')
    .padding(15)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .shadow({ radius: 5, color: '#E0E0E0', offsetX: 0, offsetY: 2 })
    .onClick(() => {
      if (this.onItemClick) {
        this.onItemClick(this.music);
      }
    })
  }
}
