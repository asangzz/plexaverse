// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contest_path.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NodePart _$NodePartFromJson(Map<String, dynamic> json) => _NodePart(
  index: (json['index'] as num?)?.toInt() ?? 1,
  total: (json['total'] as num?)?.toInt() ?? 1,
  start: (json['start'] as num?)?.toInt(),
  end: (json['end'] as num?)?.toInt(),
);

Map<String, dynamic> _$NodePartToJson(_NodePart instance) => <String, dynamic>{
  'index': instance.index,
  'total': instance.total,
  'start': instance.start,
  'end': instance.end,
};

_FollowProgress _$FollowProgressFromJson(Map<String, dynamic> json) =>
    _FollowProgress(
      done: (json['done'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FollowProgressToJson(_FollowProgress instance) =>
    <String, dynamic>{'done': instance.done, 'total': instance.total};

_NodeSetup _$NodeSetupFromJson(Map<String, dynamic> json) => _NodeSetup(
  dayIndex: (json['dayIndex'] as num?)?.toInt() ?? 0,
  step:
      $enumDecodeNullable(
        _$SetupStepEnumMap,
        json['step'],
        unknownValue: SetupStep.unknown,
      ) ??
      SetupStep.unknown,
  imageKind: json['imageKind'] as String?,
  photoGuide: json['photoGuide'] as String?,
);

Map<String, dynamic> _$NodeSetupToJson(_NodeSetup instance) =>
    <String, dynamic>{
      'dayIndex': instance.dayIndex,
      'step': _$SetupStepEnumMap[instance.step]!,
      'imageKind': instance.imageKind,
      'photoGuide': instance.photoGuide,
    };

const _$SetupStepEnumMap = {
  SetupStep.post: 'post',
  SetupStep.image: 'image',
  SetupStep.unknown: 'unknown',
};

_NodeClaim _$NodeClaimFromJson(Map<String, dynamic> json) => _NodeClaim(
  kind:
      $enumDecodeNullable(
        _$ClaimKindEnumMap,
        json['kind'],
        unknownValue: ClaimKind.unknown,
      ) ??
      ClaimKind.unknown,
  occurrence: json['occurrence'] as String? ?? '',
);

Map<String, dynamic> _$NodeClaimToJson(_NodeClaim instance) =>
    <String, dynamic>{
      'kind': _$ClaimKindEnumMap[instance.kind]!,
      'occurrence': instance.occurrence,
    };

const _$ClaimKindEnumMap = {
  ClaimKind.article: 'article',
  ClaimKind.video: 'video',
  ClaimKind.unknown: 'unknown',
};

_PathNode _$PathNodeFromJson(Map<String, dynamic> json) => _PathNode(
  id: json['id'] as String? ?? '',
  kind:
      $enumDecodeNullable(
        _$PathNodeKindEnumMap,
        json['kind'],
        unknownValue: PathNodeKind.unknown,
      ) ??
      PathNodeKind.unknown,
  state:
      $enumDecodeNullable(
        _$PathNodeStateEnumMap,
        _stateUnlessUnknown(json, 'state'),
        unknownValue: PathNodeState.locked,
      ) ??
      PathNodeState.locked,
  title: json['title'] as String? ?? '',
  points: (json['points'] as num?)?.toInt() ?? 0,
  href: _hrefUnlessUnknown(json, 'href') as String?,
  detail: json['detail'] as String?,
  started: json['started'] as bool? ?? false,
  part: json['part'] == null
      ? null
      : NodePart.fromJson(json['part'] as Map<String, dynamic>),
  claim: json['claim'] == null
      ? null
      : NodeClaim.fromJson(json['claim'] as Map<String, dynamic>),
  follow: json['follow'] == null
      ? null
      : FollowProgress.fromJson(json['follow'] as Map<String, dynamic>),
  canSkip: _canSkipUnlessUnknown(json, 'canSkip') as bool? ?? false,
  setup: json['setup'] == null
      ? null
      : NodeSetup.fromJson(json['setup'] as Map<String, dynamic>),
  openAllWeek: _openAllWeekUnlessUnknown(json, 'openAllWeek') as bool? ?? false,
);

Map<String, dynamic> _$PathNodeToJson(_PathNode instance) => <String, dynamic>{
  'id': instance.id,
  'kind': _$PathNodeKindEnumMap[instance.kind]!,
  'state': _$PathNodeStateEnumMap[instance.state]!,
  'title': instance.title,
  'points': instance.points,
  'href': instance.href,
  'detail': instance.detail,
  'started': instance.started,
  'part': instance.part?.toJson(),
  'claim': instance.claim?.toJson(),
  'follow': instance.follow?.toJson(),
  'canSkip': instance.canSkip,
  'setup': instance.setup?.toJson(),
  'openAllWeek': instance.openAllWeek,
};

const _$PathNodeKindEnumMap = {
  PathNodeKind.lesson: 'lesson',
  PathNodeKind.connectLeaders: 'connect_leaders',
  PathNodeKind.comment: 'comment',
  PathNodeKind.feedComments: 'feed_comments',
  PathNodeKind.weeklyInvites: 'weekly_invites',
  PathNodeKind.planWeek: 'plan_week',
  PathNodeKind.article: 'article',
  PathNodeKind.video: 'video',
  PathNodeKind.followWinners: 'follow_winners',
  PathNodeKind.unknown: 'unknown',
};

const _$PathNodeStateEnumMap = {
  PathNodeState.locked: 'locked',
  PathNodeState.today: 'today',
  PathNodeState.done: 'done',
  PathNodeState.missed: 'missed',
  PathNodeState.pending: 'pending',
  PathNodeState.approved: 'approved',
  PathNodeState.rejected: 'rejected',
  PathNodeState.revoked: 'revoked',
  PathNodeState.unavailable: 'unavailable',
  PathNodeState.skipped: 'skipped',
};

_PathDay _$PathDayFromJson(Map<String, dynamic> json) => _PathDay(
  dayNumber: (json['dayNumber'] as num?)?.toInt() ?? 0,
  dayKey: json['dayKey'] as String? ?? '',
  weekday: (json['weekday'] as num?)?.toInt() ?? 0,
  isToday: json['isToday'] as bool? ?? false,
  nodes:
      (json['nodes'] as List<dynamic>?)
          ?.map((e) => PathNode.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PathNode>[],
);

Map<String, dynamic> _$PathDayToJson(_PathDay instance) => <String, dynamic>{
  'dayNumber': instance.dayNumber,
  'dayKey': instance.dayKey,
  'weekday': instance.weekday,
  'isToday': instance.isToday,
  'nodes': instance.nodes.map((e) => e.toJson()).toList(),
};

_PostClaim _$PostClaimFromJson(Map<String, dynamic> json) => _PostClaim(
  kind:
      $enumDecodeNullable(
        _$ClaimKindEnumMap,
        json['kind'],
        unknownValue: ClaimKind.unknown,
      ) ??
      ClaimKind.unknown,
  occurrence: json['occurrence'] as String? ?? '',
  title: json['title'] as String? ?? '',
  postingDayKey: json['postingDayKey'] as String?,
  opensOnKey: json['opensOnKey'] as String?,
  status:
      $enumDecodeNullable(
        _$ClaimStatusEnumMap,
        json['status'],
        unknownValue: ClaimStatus.notReady,
      ) ??
      ClaimStatus.notReady,
  postUrl: json['postUrl'] as String?,
  points: (json['points'] as num?)?.toInt() ?? 0,
  rejectReason: json['rejectReason'] as String?,
);

Map<String, dynamic> _$PostClaimToJson(_PostClaim instance) =>
    <String, dynamic>{
      'kind': _$ClaimKindEnumMap[instance.kind]!,
      'occurrence': instance.occurrence,
      'title': instance.title,
      'postingDayKey': instance.postingDayKey,
      'opensOnKey': instance.opensOnKey,
      'status': _$ClaimStatusEnumMap[instance.status]!,
      'postUrl': instance.postUrl,
      'points': instance.points,
      'rejectReason': instance.rejectReason,
    };

const _$ClaimStatusEnumMap = {
  ClaimStatus.notReady: 'not_ready',
  ClaimStatus.open: 'open',
  ClaimStatus.pending: 'pending',
  ClaimStatus.approved: 'approved',
  ClaimStatus.rejected: 'rejected',
};

_FeedCommentsRule _$FeedCommentsRuleFromJson(Map<String, dynamic> json) =>
    _FeedCommentsRule(
      perDay: (json['perDay'] as num?)?.toInt() ?? 5,
      points: (json['points'] as num?)?.toInt() ?? 0,
      penalty: (json['penalty'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FeedCommentsRuleToJson(_FeedCommentsRule instance) =>
    <String, dynamic>{
      'perDay': instance.perDay,
      'points': instance.points,
      'penalty': instance.penalty,
    };

_WeekReward _$WeekRewardFromJson(Map<String, dynamic> json) => _WeekReward(
  points: (json['points'] as num?)?.toInt() ?? 0,
  earned: json['earned'] as bool? ?? false,
  paid: (json['paid'] as num?)?.toInt(),
  missedDay: json['missedDay'] as bool? ?? false,
);

Map<String, dynamic> _$WeekRewardToJson(_WeekReward instance) =>
    <String, dynamic>{
      'points': instance.points,
      'earned': instance.earned,
      'paid': instance.paid,
      'missedDay': instance.missedDay,
    };

_ContestPath _$ContestPathFromJson(Map<String, dynamic> json) => _ContestPath(
  status:
      $enumDecodeNullable(
        _$ContestPathStatusEnumMap,
        json['status'],
        unknownValue: ContestPathStatus.noContest,
      ) ??
      ContestPathStatus.noContest,
  contestId: json['contestId'] as String?,
  dayNumber: (json['dayNumber'] as num?)?.toInt(),
  finalDay: (json['finalDay'] as num?)?.toInt(),
  weekNumber: (json['weekNumber'] as num?)?.toInt(),
  days:
      (json['days'] as List<dynamic>?)
          ?.map((e) => PathDay.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PathDay>[],
  claims:
      (json['claims'] as List<dynamic>?)
          ?.map((e) => PostClaim.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PostClaim>[],
  feedComments: json['feedComments'] == null
      ? null
      : FeedCommentsRule.fromJson(json['feedComments'] as Map<String, dynamic>),
  weekReward: json['weekReward'] == null
      ? null
      : WeekReward.fromJson(json['weekReward'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ContestPathToJson(_ContestPath instance) =>
    <String, dynamic>{
      'status': _$ContestPathStatusEnumMap[instance.status]!,
      'contestId': instance.contestId,
      'dayNumber': instance.dayNumber,
      'finalDay': instance.finalDay,
      'weekNumber': instance.weekNumber,
      'days': instance.days.map((e) => e.toJson()).toList(),
      'claims': instance.claims.map((e) => e.toJson()).toList(),
      'feedComments': instance.feedComments?.toJson(),
      'weekReward': instance.weekReward?.toJson(),
    };

const _$ContestPathStatusEnumMap = {
  ContestPathStatus.noContest: 'no_contest',
  ContestPathStatus.notJoined: 'not_joined',
  ContestPathStatus.upcoming: 'upcoming',
  ContestPathStatus.ended: 'ended',
  ContestPathStatus.running: 'running',
};
