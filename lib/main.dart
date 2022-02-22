import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Member>> _onLoadData() async {
    const url = "https://h5.48.cn/resource/jsonp/allmembers.php?gid=10";
    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) {
      throw ("error");
    }
    final json = convert.jsonDecode(res.body);
    final members = json["rows"].map<Member>((item) {
      return Member(
        id: item["sid"],
        name: item["sname"],
        team: item["tname"],
        pinyin: item["pinyin"],
        abbr: item["abbr"],
        tid: item["tid"],
        pid: item["pid"],
        pName: item["pname"],
        nickname: item["nickname"],
        company: item["company"],
        joinDay: item["join_day"],
        height: item["height"],
        birthDay: item["birth_day"],
        starSign12: item["star_sign_12"],
        starSign48: item["star_sign_48"],
        birthPlace: item["birth_place"],
        speciality: item["speciality"],
        hobby: item["hobby"],
      );
    }).toList();
    return members;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Member>>(
        future: _onLoadData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Member> members = snapshot.data!;
            if (members.isEmpty) {
              return const Center(
                child: Text('Opps!! data is empty'),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                final _members = await _onLoadData();
                setState(() => members = _members);
              },
              child: Scrollbar(
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(),
                    SliverPersistentHeader(
                      delegate:
                          _MyDeleglate("SII Team", const Color(0xff91cbed)),
                      pinned: true,
                    ),
                    _buildTeamList(members, "SII"),
                    SliverPersistentHeader(
                      delegate:
                          _MyDeleglate("NII Team", const Color(0xffae86bb)),
                      pinned: true,
                    ),
                    _buildTeamList(members, "NII"),
                    SliverPersistentHeader(
                      delegate:
                          _MyDeleglate("HII Team", const Color(0xfff39800)),
                      pinned: true,
                    ),
                    _buildTeamList(members, "HII"),
                    SliverPersistentHeader(
                      delegate: _MyDeleglate("X Team", const Color(0xffa9cc29)),
                      pinned: true,
                    ),
                    _buildTeamList(members, "X"),
                    SliverPersistentHeader(
                      delegate: _MyDeleglate("预备生", const Color(0xffa9cc29)),
                      pinned: true,
                    ),
                    _buildTeamList(members, "预备生"),
                  ],
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('some Error ...'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  SliverSafeArea _buildTeamList(List<Member> members, String teamName) {
    final teamMembers =
        members.where((member) => member.team == teamName).toList();
    return SliverSafeArea(
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final member = teamMembers[index];
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => DetailPage(
                      member: member,
                    ),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: member.avatarUrl,
                    child: ClipOval(
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 32,
                        child: Image.network(member.avatarUrl),
                      ),
                    ),
                  ),
                  Text(member.name),
                ],
              ),
            );
          },
          childCount: teamMembers.length,
        ),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100,
        ),
      ),
    );
  }
}

class _MyDeleglate extends SliverPersistentHeaderDelegate {
  final String title;
  final Color color;

  _MyDeleglate(this.title, this.color);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: color,
      height: maxExtent,
      child: FittedBox(child: Text(title)),
    );
  }

  @override
  double get maxExtent => 32;

  @override
  double get minExtent => 32;

  @override
  bool shouldRebuild(covariant _MyDeleglate oldDelegate) {
    return oldDelegate.title != title;
  }
}

class Member {
  final String id;
  final String name;
  final String team;
  final String pinyin;
  final String abbr;
  final String tid;
  final String pid;
  final String pName;
  final String nickname;
  final String company;
  final String joinDay;
  final String height;
  final String birthDay;
  final String starSign12;
  final String starSign48;
  final String birthPlace;
  final String speciality;
  final String hobby;

  Member({
    required this.id,
    required this.name,
    required this.team,
    required this.pinyin,
    required this.abbr,
    required this.tid,
    required this.pid,
    required this.pName,
    required this.nickname,
    required this.company,
    required this.joinDay,
    required this.height,
    required this.birthDay,
    required this.starSign12,
    required this.starSign48,
    required this.birthPlace,
    required this.speciality,
    required this.hobby,
  });

  String get avatarUrl => "https://www.snh48.com/images/member/zp_$id.jpg";

  @override
  String toString() {
    return "$id: $name";
  }
}

class DetailPage extends StatelessWidget {
  final Member member;

  const DetailPage({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: const BackButton(color: Colors.black,),
          backgroundColor: Colors.pink[100],
          pinned: true,
          stretch: true,
          expandedHeight: 300,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              "SNH48-${member.name}",
              style: TextStyle(color: Colors.grey[800]),
            ),
            background: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        'https://media.istockphoto.com/vectors/pink-bokeh-background-vector-illustration-vector-id1307576318?b=1&k=20&m=1307576318&s=612x612&w=0&h=O-Vtj-2nKXMMP2rL-MWrfiI8Ap_1yJEXsUSicgSARXk=',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(height: 2, color:Colors.pink[200]),
                    const Spacer(),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(100.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Hero(
                        tag: member.avatarUrl,
                        child: Material(
                          elevation: 4.0,
                          shape: const CircleBorder(),
                          child: ClipOval(
                              child: Image.network(
                            member.avatarUrl,
                            fit: BoxFit.cover,
                          )),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            collapseMode: CollapseMode.pin,
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            _buildInfo("拼音", member.pinyin),
            _buildInfo("加入所属", member.pName),
            _buildInfo("昵称", member.nickname),
            _buildInfo("加入日期", member.company),
            _buildInfo("加入日期", member.joinDay),
            _buildInfo("身高", member.height),
            _buildInfo("生日", member.birthDay),
            _buildInfo("星座", member.starSign12),
            _buildInfo("出生地", member.birthPlace),
            _buildInfo("特长", member.speciality),
            _buildInfo("兴趣爱好", member.hobby),
          ]),
        )
      ],
    ));
  }

  _buildInfo(String label, String content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(label),
            Text(
              content,
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }
}
