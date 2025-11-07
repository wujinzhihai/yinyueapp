import { Song } from '../models/Song'
import http from '@ohos.net.http'

/**
 * 搜索结果接口
 */
interface SearchResult {
  songs: TrackInfo[];
  songCount?: number;
}

/**
 * 歌词信息接口
 */
interface LyricInfo {
  lyric: string;
}

/**
 * API响应接口
 */
interface ApiResponse {
  code: number;
  result?: SearchResult;
  data?: SongUrlInfo[];
  lrc?: LyricInfo;
}

/**
 * 歌曲信息接口
 */
interface TrackInfo {
  id: number;
  name: string;
  artists: ArtistInfo[];
  album: AlbumInfo;
  duration?: number;
}

/**
 * 艺术家信息接口
 */
interface ArtistInfo {
  id: number;
  name: string;
}

/**
 * 专辑信息接口
 */
interface AlbumInfo {
  id: number;
  name: string;
  picUrl: string;
}

/**
 * 歌曲URL信息接口
 */
interface SongUrlInfo {
  id: number;
  url: string;
  type?: string;
}

/**
 * 音乐API服务 - 使用模拟数据版本
 */
export class MusicApiService {
  // ✅ 本地API地址（暂未使用）
  private static readonly API_BASE: string = 'http://localhost:3000'

  /**
   * 发送HTTP请求
   */
  private static async request(url: string): Promise<ApiResponse> {
    const httpRequest = http.createHttp()

    try {
      console.info(`[MusicAPI] 请求: ${url}`)

      const response = await httpRequest.request(url, {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        },
        connectTimeout: 5000,
        readTimeout: 5000
      })

      if (response.responseCode === 200) {
        const data: ApiResponse = JSON.parse(response.result.toString())
        console.info(`[MusicAPI] 响应成功`)
        return data
      } else {
        console.error(`[MusicAPI] 请求失败: ${response.responseCode}`)
        const error = new Error(`HTTP ${response.responseCode}`)
        throw error
      }
    } catch (error) {
      console.error(`[MusicAPI] 请求异常:`, error)
      const err = new Error('Request failed')
      throw err
    } finally {
      httpRequest.destroy()
    }
  }

  /**
   * 获取热门歌曲（使用模拟数据）
   */
  static async getHotSongs(limit: number = 20): Promise<Song[]> {
    console.info(`[MusicAPI] 使用模拟数据（本地API未配置）`)

    // ✅ 模拟数据（真实的网易云音乐ID和信息）
    const mockSongs: Song[] = [
      new Song(
        186016,
        '晴天',
        '周杰伦',
        '叶惠美',
        'https://p1.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg',
        269,
        'https://music.163.com/song/media/outer/url?id=186016.mp3'
      ),
      new Song(
        186017,
        '夜曲',
        '周杰伦',
        '十一月的萧邦',
        'https://p1.music.126.net/5zs7IvmLv7KahY3BFzUmrg==/109951163511560406.jpg',
        234,
        'https://music.163.com/song/media/outer/url?id=186017.mp3'
      ),
      new Song(
        185668,
        '七里香',
        '周杰伦',
        '七里香',
        'https://p1.music.126.net/p5R-8S1qEbL6GVI8UGi7hA==/109951168291015305.jpg',
        302,
        'https://music.163.com/song/media/outer/url?id=185668.mp3'
      ),
      new Song(
        185809,
        '简单爱',
        '周杰伦',
        '范特西',
        'https://p1.music.126.net/bO_R1MWN3iFZ5GLI00pgOw==/109951165665999498.jpg',
        270,
        'https://music.163.com/song/media/outer/url?id=185809.mp3'
      ),
      new Song(
        185954,
        '青花瓷',
        '周杰伦',
        '我很忙',
        'https://p1.music.126.net/Md3RLH0fe2a_3dMDnfqoQg==/18590542604286213.jpg',
        235,
        'https://music.163.com/song/media/outer/url?id=185954.mp3'
      ),
      new Song(
        185868,
        '稻香',
        '周杰伦',
        '魔杰座',
        'https://p1.music.126.net/g8fGJuEfUq4E0Fxy1L_aNg==/109951168242729185.jpg',
        223,
        'https://music.163.com/song/media/outer/url?id=185868.mp3'
      ),
      new Song(
        436514312,
        '告白气球',
        '周杰伦',
        '周杰伦的床边故事',
        'https://p1.music.126.net/85eIYWX6p-Yx5kqpqLwxng==/109951167918377886.jpg',
        203,
        'https://music.163.com/song/media/outer/url?id=436514312.mp3'
      ),
      new Song(
        536570896,
        '等你下课',
        '周杰伦',
        '等你下课',
        'https://p1.music.126.net/XHW_zjLkGufOyKWbqx9ylQ==/109951163074811772.jpg',
        273,
        'https://music.163.com/song/media/outer/url?id=536570896.mp3'
      ),
      new Song(
        1416767593,
        '说好不哭',
        '周杰伦',
        '说好不哭',
        'https://p1.music.126.net/dLyNoWDqFVaF9PzOPfmjgQ==/109951164409179978.jpg',
        292,
        'https://music.163.com/song/media/outer/url?id=1416767593.mp3'
      ),
      new Song(
        1868553,
        '最伟大的作品',
        '周杰伦',
        '最伟大的作品',
        'https://p1.music.126.net/N2NhDPNrzv5YDR1P5K1Geg==/109951167506949787.jpg',
        289,
        'https://music.163.com/song/media/outer/url?id=1868553.mp3'
      ),
      new Song(
        185879,
        '彩虹',
        '周杰伦',
        '我很忙',
        'https://p1.music.126.net/Md3RLH0fe2a_3dMDnfqoQg==/18590542604286213.jpg',
        265,
        'https://music.163.com/song/media/outer/url?id=185879.mp3'
      ),
      new Song(
        185910,
        '蒲公英的约定',
        '周杰伦',
        '我很忙',
        'https://p1.music.126.net/Md3RLH0fe2a_3dMDnfqoQg==/18590542604286213.jpg',
        238,
        'https://music.163.com/song/media/outer/url?id=185910.mp3'
      ),
      new Song(
        185707,
        '龙卷风',
        '周杰伦',
        'Jay',
        'https://p1.music.126.net/UeTuwE7pvjBpypWLudqukA==/3431575794705467.jpg',
        254,
        'https://music.163.com/song/media/outer/url?id=185707.mp3'
      ),
      new Song(
        185692,
        '开不了口',
        '周杰伦',
        '范特西',
        'https://p1.music.126.net/bO_R1MWN3iFZ5GLI00pgOw==/109951165665999498.jpg',
        283,
        'https://music.163.com/song/media/outer/url?id=185692.mp3'
      ),
      new Song(
        185876,
        '我不配',
        '周杰伦',
        '我很忙',
        'https://p1.music.126.net/Md3RLH0fe2a_3dMDnfqoQg==/18590542604286213.jpg',
        319,
        'https://music.163.com/song/media/outer/url?id=185876.mp3'
      ),
      new Song(
        185661,
        '以父之名',
        '周杰伦',
        '叶惠美',
        'https://p1.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg',
        334,
        'https://music.163.com/song/media/outer/url?id=185661.mp3'
      ),
      new Song(
        185788,
        '暗号',
        '周杰伦',
        '八度空间',
        'https://p1.music.126.net/qKF4A6aMiEpIDWMQRLHI3A==/109951165645066445.jpg',
        266,
        'https://music.163.com/song/media/outer/url?id=185788.mp3'
      ),
      new Song(
        185800,
        '回到过去',
        '周杰伦',
        '八度空间',
        'https://p1.music.126.net/qKF4A6aMiEpIDWMQRLHI3A==/109951165645066445.jpg',
        229,
        'https://music.163.com/song/media/outer/url?id=185800.mp3'
      ),
      new Song(
        185718,
        '星晴',
        '周杰伦',
        'Jay',
        'https://p1.music.126.net/UeTuwE7pvjBpypWLudqukA==/3431575794705467.jpg',
        275,
        'https://music.163.com/song/media/outer/url?id=185718.mp3'
      ),
      new Song(
        185770,
        '园游会',
        '周杰伦',
        '八度空间',
        'https://p1.music.126.net/qKF4A6aMiEpIDWMQRLHI3A==/109951165645066445.jpg',
        234,
        'https://music.163.com/song/media/outer/url?id=185770.mp3'
      )
    ]

    console.info(`[MusicAPI] 返回 ${Math.min(mockSongs.length, limit)} 首模拟歌曲`)
    return mockSongs.slice(0, limit)
  }

  /**
   * 搜索歌曲（使用模拟数据）
   */
  static async searchSongs(keyword: string, limit: number = 20): Promise<Song[]> {
    console.info(`[MusicAPI] 搜索歌曲: "${keyword}" (使用模拟数据)`)

    // ✅ 先获取所有模拟歌曲
    const allSongs = await MusicApiService.getHotSongs(20)

    // ✅ 简单的关键词过滤
    const filteredSongs = allSongs.filter(song =>
    song.name.toLowerCase().includes(keyword.toLowerCase()) ||
    song.artist.toLowerCase().includes(keyword.toLowerCase()) ||
    song.album.toLowerCase().includes(keyword.toLowerCase())
    )

    console.info(`[MusicAPI] 搜索完成，找到 ${filteredSongs.length} 首歌曲`)
    return filteredSongs.slice(0, limit)
  }

  /**
   * 获取歌词（使用模拟数据）
   */
  static async getLyric(songId: number): Promise<string> {
    console.info(`[MusicAPI] 获取歌词: ${songId} (使用模拟数据)`)

    // ✅ 简单的模拟歌词
    const mockLyrics: Record<number, string> = {
      186016: `[00:00.00] 晴天 - 周杰伦
[00:15.00] 故事的小黄花
[00:18.00] 从出生那年就飘着
[00:22.00] 童年的荡秋千
[00:25.00] 随记忆一直晃到现在`,

      186017: `[00:00.00] 夜曲 - 周杰伦
[00:15.00] 一群嗜血的蚂蚁
[00:18.00] 被腐肉所吸引
[00:22.00] 我面无表情
[00:25.00] 看孤独的风景`,

      185668: `[00:00.00] 七里香 - 周杰伦
[00:15.00] 窗外的麻雀
[00:18.00] 在电线杆上多嘴
[00:22.00] 你说这一句
[00:25.00] 很有夏天的感觉`
    }

    // ✅ 返回对应歌词或默认歌词
    const lyric = mockLyrics[songId] || '[00:00.00] 暂无歌词'
    console.info(`[MusicAPI] 歌词获取成功`)
    return lyric
  }
}
