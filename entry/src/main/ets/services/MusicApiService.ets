import { MusicItem } from '../models/MusicItem';

// 固定的Mock数据 - 50首歌曲
const MOCK_MUSIC_DATA: MusicItem[] = [
  { id: '1', title: '晴天', artist: '周杰伦', coverUrl: 'https://picsum.photos/200?random=1', audioUrl: 'https://example.com/audio1.mp3' },
  { id: '2', title: '七里香', artist: '周杰伦', coverUrl: 'https://picsum.photos/200?random=2', audioUrl: 'https://example.com/audio2.mp3' },
  { id: '3', title: '稻香', artist: '周杰伦', coverUrl: 'https://picsum.photos/200?random=3', audioUrl: 'https://example.com/audio3.mp3' },
  { id: '4', title: '夜曲', artist: '周杰伦', coverUrl: 'https://picsum.photos/200?random=4', audioUrl: 'https://example.com/audio4.mp3' },
  { id: '5', title: '青花瓷', artist: '周杰伦', coverUrl: 'https://picsum.photos/200?random=5', audioUrl: 'https://example.com/audio5.mp3' },
  { id: '6', title: '东风破', artist: '周杰伦', coverUrl: 'https://picsum.photos/200?random=6', audioUrl: 'https://example.com/audio6.mp3' },
  { id: '7', title: '发如雪', artist: '周杰伦', coverUrl: 'https://picsum.photos/200?random=7', audioUrl: 'https://example.com/audio7.mp3' },
  { id: '8', title: '简单爱', artist: '周杰伦', coverUrl: 'https://picsum.photos/200?random=8', audioUrl: 'https://example.com/audio8.mp3' },
  { id: '9', title: '以父之名', artist: '周杰伦', coverUrl: 'https://picsum.photos/200?random=9', audioUrl: 'https://example.com/audio9.mp3' },
  { id: '10', title: '龙卷风', artist: '周杰伦', coverUrl: 'https://picsum.photos/200?random=10', audioUrl: 'https://example.com/audio10.mp3' },
  { id: '11', title: '演员', artist: '薛之谦', coverUrl: 'https://picsum.photos/200?random=11', audioUrl: 'https://example.com/audio11.mp3' },
  { id: '12', title: '丑八怪', artist: '薛之谦', coverUrl: 'https://picsum.photos/200?random=12', audioUrl: 'https://example.com/audio12.mp3' },
  { id: '13', title: '认真的雪', artist: '薛之谦', coverUrl: 'https://picsum.photos/200?random=13', audioUrl: 'https://example.com/audio13.mp3' },
  { id: '14', title: '暧昧', artist: '薛之谦', coverUrl: 'https://picsum.photos/200?random=14', audioUrl: 'https://example.com/audio14.mp3' },
  { id: '15', title: '绅士', artist: '薛之谦', coverUrl: 'https://picsum.photos/200?random=15', audioUrl: 'https://example.com/audio15.mp3' },
  { id: '16', title: '十年', artist: '陈奕迅', coverUrl: 'https://picsum.photos/200?random=16', audioUrl: 'https://example.com/audio16.mp3' },
  { id: '17', title: '浮夸', artist: '陈奕迅', coverUrl: 'https://picsum.photos/200?random=17', audioUrl: 'https://example.com/audio17.mp3' },
  { id: '18', title: '富士山下', artist: '陈奕迅', coverUrl: 'https://picsum.photos/200?random=18', audioUrl: 'https://example.com/audio18.mp3' },
  { id: '19', title: '爱情转移', artist: '陈奕迅', coverUrl: 'https://picsum.photos/200?random=19', audioUrl: 'https://example.com/audio19.mp3' },
  { id: '20', title: '红玫瑰', artist: '陈奕迅', coverUrl: 'https://picsum.photos/200?random=20', audioUrl: 'https://example.com/audio20.mp3' },
  { id: '21', title: '告白气球', artist: '周杰伦', coverUrl: 'https://picsum.photos/200?random=21', audioUrl: 'https://example.com/audio21.mp3' },
  { id: '22', title: '等你下课', artist: '周杰伦', coverUrl: 'https://picsum.photos/200?random=22', audioUrl: 'https://example.com/audio22.mp3' },
  { id: '23', title: '说好不哭', artist: '周杰伦', coverUrl: 'https://picsum.photos/200?random=23', audioUrl: 'https://example.com/audio23.mp3' },
  { id: '24', title: '最伟大的作品', artist: '周杰伦', coverUrl: 'https://picsum.photos/200?random=24', audioUrl: 'https://example.com/audio24.mp3' },
  { id: '25', title: '夜的第七章', artist: '周杰伦', coverUrl: 'https://picsum.photos/200?random=25', audioUrl: 'https://example.com/audio25.mp3' },
  { id: '26', title: '成都', artist: '赵雷', coverUrl: 'https://picsum.photos/200?random=26', audioUrl: 'https://example.com/audio26.mp3' },
  { id: '27', title: '理想', artist: '赵雷', coverUrl: 'https://picsum.photos/200?random=27', audioUrl: 'https://example.com/audio27.mp3' },
  { id: '28', title: '南方姑娘', artist: '赵雷', coverUrl: 'https://picsum.photos/200?random=28', audioUrl: 'https://example.com/audio28.mp3' },
  { id: '29', title: '消愁', artist: '毛不易', coverUrl: 'https://picsum.photos/200?random=29', audioUrl: 'https://example.com/audio29.mp3' },
  { id: '30', title: '像我这样的人', artist: '毛不易', coverUrl: 'https://picsum.photos/200?random=30', audioUrl: 'https://example.com/audio30.mp3' },
  { id: '31', title: '平凡的一天', artist: '毛不易', coverUrl: 'https://picsum.photos/200?random=31', audioUrl: 'https://example.com/audio31.mp3' },
  { id: '32', title: '起风了', artist: '买辣椒也用券', coverUrl: 'https://picsum.photos/200?random=32', audioUrl: 'https://example.com/audio32.mp3' },
  { id: '33', title: '夏天的风', artist: '温岚', coverUrl: 'https://picsum.photos/200?random=33', audioUrl: 'https://example.com/audio33.mp3' },
  { id: '34', title: '漂洋过海来看你', artist: '刘明湘', coverUrl: 'https://picsum.photos/200?random=34', audioUrl: 'https://example.com/audio34.mp3' },
  { id: '35', title: '小幸运', artist: '田馥甄', coverUrl: 'https://picsum.photos/200?random=35', audioUrl: 'https://example.com/audio35.mp3' },
  { id: '36', title: '岁月神偷', artist: '金玟岐', coverUrl: 'https://picsum.photos/200?random=36', audioUrl: 'https://example.com/audio36.mp3' },
  { id: '37', title: '体面', artist: '于文文', coverUrl: 'https://picsum.photos/200?random=37', audioUrl: 'https://example.com/audio37.mp3' },
  { id: '38', title: '刚好遇见你', artist: '李玉刚', coverUrl: 'https://picsum.photos/200?random=38', audioUrl: 'https://example.com/audio38.mp3' },
  { id: '39', title: '后来', artist: '刘若英', coverUrl: 'https://picsum.photos/200?random=39', audioUrl: 'https://example.com/audio39.mp3' },
  { id: '40', title: '匆匆那年', artist: '王菲', coverUrl: 'https://picsum.photos/200?random=40', audioUrl: 'https://example.com/audio40.mp3' },
  { id: '41', title: '追光者', artist: '岑宁儿', coverUrl: 'https://picsum.photos/200?random=41', audioUrl: 'https://example.com/audio41.mp3' },
  { id: '42', title: '光年之外', artist: '邓紫棋', coverUrl: 'https://picsum.photos/200?random=42', audioUrl: 'https://example.com/audio42.mp3' },
  { id: '43', title: '泡沫', artist: '邓紫棋', coverUrl: 'https://picsum.photos/200?random=43', audioUrl: 'https://example.com/audio43.mp3' },
  { id: '44', title: '喜欢你', artist: '邓紫棋', coverUrl: 'https://picsum.photos/200?random=44', audioUrl: 'https://example.com/audio44.mp3' },
  { id: '45', title: '画', artist: '邓紫棋', coverUrl: 'https://picsum.photos/200?random=45', audioUrl: 'https://example.com/audio45.mp3' },
  { id: '46', title: '南山南', artist: '马頔', coverUrl: 'https://picsum.photos/200?random=46', audioUrl: 'https://example.com/audio46.mp3' },
  { id: '47', title: '董小姐', artist: '宋冬野', coverUrl: 'https://picsum.photos/200?random=47', audioUrl: 'https://example.com/audio47.mp3' },
  { id: '48', title: '斑马斑马', artist: '宋冬野', coverUrl: 'https://picsum.photos/200?random=48', audioUrl: 'https://example.com/audio48.mp3' },
  { id: '49', title: '安和桥', artist: '宋冬野', coverUrl: 'https://picsum.photos/200?random=49', audioUrl: 'https://example.com/audio49.mp3' },
  { id: '50', title: '模特', artist: '李荣浩', coverUrl: 'https://picsum.photos/200?random=50', audioUrl: 'https://example.com/audio50.mp3' }
];

class MusicApiService {
  // 获取音乐列表
  async fetchMusicList(): Promise<MusicItem[]> {
    // 模拟网络延迟
    await new Promise<void>((resolve: () => void) => setTimeout(resolve, 1000));

    // 返回固定的Mock数据
    return MOCK_MUSIC_DATA;
  }

  // 搜索音乐
  async searchMusic(keyword: string): Promise<MusicItem[]> {
    // 模拟网络延迟
    await new Promise<void>((resolve: () => void) => setTimeout(resolve, 800));

    // 如果关键字为空，返回全部数据
    if (!keyword || keyword.trim() === '') {
      return MOCK_MUSIC_DATA;
    }

    // 从固定数据中过滤搜索
    const lowerKeyword = keyword.toLowerCase();
    return MOCK_MUSIC_DATA.filter((item: MusicItem): boolean =>
    item.title.toLowerCase().includes(lowerKeyword) ||
    item.artist.toLowerCase().includes(lowerKeyword)
    );
  }
}

export default new MusicApiService();
