// D:\hongmengxitong\MusicApp\entry\src\main\ets\services\MusicApiService.ets
import { Song } from '../models/Song'

/**
 * 音乐API服务（静态方法类）
 * ✅ 关键：必须添加 export 关键字
 */
export class MusicApiService {
  /**
   * 获取热门歌曲列表
   */
  static async getHotSongs(): Promise<Song[]> {
    console.info('[MusicApiService] 获取热门歌曲')

    // ✅ 模拟数据（实际项目中应从网络API获取）
    return [
      new Song(
        1,
        '夜曲',
        '周杰伦',
        '十一月的萧邦',
        $r('sys.media.ohos_app_icon'),
        'http://music.163.com/song/media/outer/url?id=25906124.mp3',
        240000
      ),
      new Song(
        2,
        '稻香',
        '周杰伦',
        '魔杰座',
        $r('sys.media.ohos_app_icon'),
        'http://music.163.com/song/media/outer/url?id=38592976.mp3',
        228000
      ),
      new Song(
        3,
        '晴天',
        '周杰伦',
        '叶惠美',
        $r('sys.media.ohos_app_icon'),
        'http://music.163.com/song/media/outer/url?id=186016.mp3',
        269000
      ),
      new Song(
        4,
        '七里香',
        '周杰伦',
        '七里香',
        $r('sys.media.ohos_app_icon'),
        'http://music.163.com/song/media/outer/url?id=186017.mp3',
        298000
      ),
      new Song(
        5,
        '青花瓷',
        '周杰伦',
        '我很忙',
        $r('sys.media.ohos_app_icon'),
        'http://music.163.com/song/media/outer/url?id=186018.mp3',
        228000
      )
    ]
  }

  /**
   * 搜索歌曲
   */
  static async searchSongs(keyword: string): Promise<Song[]> {
    console.info('[MusicApiService] 搜索歌曲:', keyword)

    // ✅ 从热门歌曲中过滤（实际项目中应调用搜索API）
    const allSongs = await MusicApiService.getHotSongs()
    return allSongs.filter(song =>
    song.name.toLowerCase().includes(keyword.toLowerCase()) ||
    song.artist.toLowerCase().includes(keyword.toLowerCase()) ||
    song.albumName.toLowerCase().includes(keyword.toLowerCase())
    )
  }

  /**
   * 根据ID获取歌曲详情
   */
  static async getSongById(id: number): Promise<Song | null> {
    console.info('[MusicApiService] 获取歌曲详情:', id)

    const allSongs = await MusicApiService.getHotSongs()
    return allSongs.find(song => song.id === id) || null
  }
}
