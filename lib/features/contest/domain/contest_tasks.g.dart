// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contest_tasks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommentPost _$CommentPostFromJson(Map<String, dynamic> json) => _CommentPost(
  author: json['author'] as String? ?? '',
  firstLine: json['firstLine'] as String? ?? '',
  postUrl: json['postUrl'] as String?,
);

Map<String, dynamic> _$CommentPostToJson(_CommentPost instance) =>
    <String, dynamic>{
      'author': instance.author,
      'firstLine': instance.firstLine,
      'postUrl': instance.postUrl,
    };

_CommentLevelView _$CommentLevelViewFromJson(Map<String, dynamic> json) =>
    _CommentLevelView(
      status:
          $enumDecodeNullable(
            _$CommentLevelStatusEnumMap,
            json['status'],
            unknownValue: CommentLevelStatus.unavailable,
          ) ??
          CommentLevelStatus.unavailable,
      reason: $enumDecodeNullable(
        _$CommentLevelReasonEnumMap,
        json['reason'],
        unknownValue: JsonKey.nullForUndefinedEnumValue,
      ),
      post: json['post'] == null
          ? null
          : CommentPost.fromJson(json['post'] as Map<String, dynamic>),
      template: json['template'] as String?,
      blankCount: (json['blankCount'] as num?)?.toInt(),
      bank:
          (json['bank'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
      firstTry: $enumDecodeNullable(
        _$CommentFirstTryEnumMap,
        json['firstTry'],
        unknownValue: JsonKey.nullForUndefinedEnumValue,
      ),
      answers:
          (json['answers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      comment: json['comment'] as String?,
      pointsApplied: (json['pointsApplied'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CommentLevelViewToJson(_CommentLevelView instance) =>
    <String, dynamic>{
      'status': _$CommentLevelStatusEnumMap[instance.status]!,
      'reason': _$CommentLevelReasonEnumMap[instance.reason],
      'post': instance.post?.toJson(),
      'template': instance.template,
      'blankCount': instance.blankCount,
      'bank': instance.bank,
      'firstTry': _$CommentFirstTryEnumMap[instance.firstTry],
      'answers': instance.answers,
      'comment': instance.comment,
      'pointsApplied': instance.pointsApplied,
    };

const _$CommentLevelStatusEnumMap = {
  CommentLevelStatus.unavailable: 'unavailable',
  CommentLevelStatus.open: 'open',
  CommentLevelStatus.done: 'done',
};

const _$CommentLevelReasonEnumMap = {
  CommentLevelReason.notToday: 'not_today',
  CommentLevelReason.noPost: 'no_post',
  CommentLevelReason.notRunning: 'not_running',
  CommentLevelReason.notJoined: 'not_joined',
  CommentLevelReason.writing: 'writing',
};

const _$CommentFirstTryEnumMap = {
  CommentFirstTry.none: 'none',
  CommentFirstTry.right: 'right',
  CommentFirstTry.wrong: 'wrong',
};

_CommentBlank _$CommentBlankFromJson(Map<String, dynamic> json) =>
    _CommentBlank(
      value: json['value'] as String? ?? '',
      correct: json['correct'] as bool? ?? false,
      answer: json['answer'] as String? ?? '',
    );

Map<String, dynamic> _$CommentBlankToJson(_CommentBlank instance) =>
    <String, dynamic>{
      'value': instance.value,
      'correct': instance.correct,
      'answer': instance.answer,
    };

_CommentSubmitResult _$CommentSubmitResultFromJson(Map<String, dynamic> json) =>
    _CommentSubmitResult(
      correct: json['correct'] as bool? ?? false,
      blanks:
          (json['blanks'] as List<dynamic>?)
              ?.map((e) => CommentBlank.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CommentBlank>[],
      firstTry: json['firstTry'] as bool? ?? false,
      pointsApplied: (json['pointsApplied'] as num?)?.toInt() ?? 0,
      level: CommentLevelView.fromJson(json['level'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommentSubmitResultToJson(
  _CommentSubmitResult instance,
) => <String, dynamic>{
  'correct': instance.correct,
  'blanks': instance.blanks.map((e) => e.toJson()).toList(),
  'firstTry': instance.firstTry,
  'pointsApplied': instance.pointsApplied,
  'level': instance.level.toJson(),
};

_FeedCommentsView _$FeedCommentsViewFromJson(Map<String, dynamic> json) =>
    _FeedCommentsView(
      status:
          $enumDecodeNullable(
            _$FeedCommentsStatusEnumMap,
            json['status'],
            unknownValue: FeedCommentsStatus.unavailable,
          ) ??
          FeedCommentsStatus.unavailable,
      reason: $enumDecodeNullable(
        _$FeedCommentsReasonEnumMap,
        json['reason'],
        unknownValue: JsonKey.nullForUndefinedEnumValue,
      ),
      perDay: (json['perDay'] as num?)?.toInt() ?? 5,
      points: (json['points'] as num?)?.toInt() ?? 0,
      shares:
          (json['shares'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      penalty: (json['penalty'] as num?)?.toInt() ?? 0,
      links:
          (json['links'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
      linkPoints: (json['linkPoints'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      pointsApplied: (json['pointsApplied'] as num?)?.toInt(),
      revokeReason: json['revokeReason'] as String?,
      pointsDeducted: (json['pointsDeducted'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FeedCommentsViewToJson(_FeedCommentsView instance) =>
    <String, dynamic>{
      'status': _$FeedCommentsStatusEnumMap[instance.status]!,
      'reason': _$FeedCommentsReasonEnumMap[instance.reason],
      'perDay': instance.perDay,
      'points': instance.points,
      'shares': instance.shares,
      'penalty': instance.penalty,
      'links': instance.links,
      'linkPoints': instance.linkPoints,
      'pointsApplied': instance.pointsApplied,
      'revokeReason': instance.revokeReason,
      'pointsDeducted': instance.pointsDeducted,
    };

const _$FeedCommentsStatusEnumMap = {
  FeedCommentsStatus.unavailable: 'unavailable',
  FeedCommentsStatus.open: 'open',
  FeedCommentsStatus.done: 'done',
  FeedCommentsStatus.revoked: 'revoked',
};

const _$FeedCommentsReasonEnumMap = {
  FeedCommentsReason.notRunning: 'not_running',
  FeedCommentsReason.notJoined: 'not_joined',
  FeedCommentsReason.notToday: 'not_today',
};

_FeedCommentSubmitResult _$FeedCommentSubmitResultFromJson(
  Map<String, dynamic> json,
) => _FeedCommentSubmitResult(
  taskId: json['taskId'] as String? ?? '',
  status:
      $enumDecodeNullable(
        _$FeedCommentSubmitStatusEnumMap,
        json['status'],
        unknownValue: FeedCommentSubmitStatus.open,
      ) ??
      FeedCommentSubmitStatus.open,
  n: (json['n'] as num?)?.toInt() ?? 1,
  pointsApplied: (json['pointsApplied'] as num?)?.toInt() ?? 0,
  dayPoints: (json['dayPoints'] as num?)?.toInt() ?? 0,
  links:
      (json['links'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$FeedCommentSubmitResultToJson(
  _FeedCommentSubmitResult instance,
) => <String, dynamic>{
  'taskId': instance.taskId,
  'status': _$FeedCommentSubmitStatusEnumMap[instance.status]!,
  'n': instance.n,
  'pointsApplied': instance.pointsApplied,
  'dayPoints': instance.dayPoints,
  'links': instance.links,
};

const _$FeedCommentSubmitStatusEnumMap = {
  FeedCommentSubmitStatus.open: 'open',
  FeedCommentSubmitStatus.done: 'done',
};

_ConnectTaskResult _$ConnectTaskResultFromJson(Map<String, dynamic> json) =>
    _ConnectTaskResult(
      taskId: json['taskId'] as String? ?? '',
      status: json['status'] as String? ?? 'done',
      pointsApplied: (json['pointsApplied'] as num?)?.toInt() ?? 0,
      alreadyDone: json['alreadyDone'] as bool? ?? false,
    );

Map<String, dynamic> _$ConnectTaskResultToJson(_ConnectTaskResult instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'status': instance.status,
      'pointsApplied': instance.pointsApplied,
      'alreadyDone': instance.alreadyDone,
    };

_InvitesSubmitResult _$InvitesSubmitResultFromJson(Map<String, dynamic> json) =>
    _InvitesSubmitResult(
      taskId: json['taskId'] as String? ?? '',
      status: json['status'] as String? ?? 'done',
      pointsApplied: (json['pointsApplied'] as num?)?.toInt() ?? 0,
      replaced: json['replaced'] as bool? ?? false,
    );

Map<String, dynamic> _$InvitesSubmitResultToJson(
  _InvitesSubmitResult instance,
) => <String, dynamic>{
  'taskId': instance.taskId,
  'status': instance.status,
  'pointsApplied': instance.pointsApplied,
  'replaced': instance.replaced,
};

_PlanWeekDay _$PlanWeekDayFromJson(Map<String, dynamic> json) => _PlanWeekDay(
  index: (json['index'] as num?)?.toInt() ?? 0,
  weekday: json['weekday'] as String? ?? '',
  dayKey: json['dayKey'] as String? ?? '',
  kind: json['kind'] == null
      ? DayKind.post
      : DayKind.parse(json['kind'] as String?),
  role: json['role'] as String?,
  formatName: json['formatName'] as String?,
  imageReady: json['imageReady'] as bool? ?? false,
  title: json['title'] as String?,
  status: json['status'] as String? ?? '',
  ready: json['ready'] as bool? ?? false,
  instruction: json['instruction'] as String? ?? '',
);

Map<String, dynamic> _$PlanWeekDayToJson(_PlanWeekDay instance) =>
    <String, dynamic>{
      'index': instance.index,
      'weekday': instance.weekday,
      'dayKey': instance.dayKey,
      'kind': _dayKindWire(instance.kind),
      'role': instance.role,
      'formatName': instance.formatName,
      'imageReady': instance.imageReady,
      'title': instance.title,
      'status': instance.status,
      'ready': instance.ready,
      'instruction': instance.instruction,
    };

_PlanWeekView _$PlanWeekViewFromJson(Map<String, dynamic> json) =>
    _PlanWeekView(
      status:
          $enumDecodeNullable(
            _$PlanWeekStatusEnumMap,
            json['status'],
            unknownValue: PlanWeekStatus.unavailable,
          ) ??
          PlanWeekStatus.unavailable,
      reason: $enumDecodeNullable(
        _$PlanWeekReasonEnumMap,
        json['reason'],
        unknownValue: JsonKey.nullForUndefinedEnumValue,
      ),
      lockedDetail: json['lockedDetail'] as String?,
      weekNumber: (json['weekNumber'] as num?)?.toInt() ?? 1,
      season: (json['season'] as num?)?.toInt() ?? 1,
      planned: json['planned'] as bool? ?? false,
      topic: json['topic'] as String?,
      plannerHref: json['plannerHref'] as String? ?? '',
      days:
          (json['days'] as List<dynamic>?)
              ?.map((e) => PlanWeekDay.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PlanWeekDay>[],
    );

Map<String, dynamic> _$PlanWeekViewToJson(_PlanWeekView instance) =>
    <String, dynamic>{
      'status': _$PlanWeekStatusEnumMap[instance.status]!,
      'reason': _$PlanWeekReasonEnumMap[instance.reason],
      'lockedDetail': instance.lockedDetail,
      'weekNumber': instance.weekNumber,
      'season': instance.season,
      'planned': instance.planned,
      'topic': instance.topic,
      'plannerHref': instance.plannerHref,
      'days': instance.days.map((e) => e.toJson()).toList(),
    };

const _$PlanWeekStatusEnumMap = {
  PlanWeekStatus.unavailable: 'unavailable',
  PlanWeekStatus.locked: 'locked',
  PlanWeekStatus.open: 'open',
  PlanWeekStatus.done: 'done',
};

const _$PlanWeekReasonEnumMap = {
  PlanWeekReason.notRunning: 'not_running',
  PlanWeekReason.notJoined: 'not_joined',
  PlanWeekReason.notToday: 'not_today',
};

_PlanWeekResult _$PlanWeekResultFromJson(Map<String, dynamic> json) =>
    _PlanWeekResult(
      taskId: json['taskId'] as String? ?? '',
      status: json['status'] as String? ?? 'done',
      alreadyDone: json['alreadyDone'] as bool? ?? false,
    );

Map<String, dynamic> _$PlanWeekResultToJson(_PlanWeekResult instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'status': instance.status,
      'alreadyDone': instance.alreadyDone,
    };

_ClaimResult _$ClaimResultFromJson(Map<String, dynamic> json) => _ClaimResult(
  taskId: json['taskId'] as String? ?? '',
  claim: PostClaim.fromJson(json['claim'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ClaimResultToJson(_ClaimResult instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'claim': instance.claim.toJson(),
    };

_SkipResult _$SkipResultFromJson(Map<String, dynamic> json) => _SkipResult(
  nodeId: json['nodeId'] as String? ?? '',
  alreadySkipped: json['alreadySkipped'] as bool? ?? false,
);

Map<String, dynamic> _$SkipResultToJson(_SkipResult instance) =>
    <String, dynamic>{
      'nodeId': instance.nodeId,
      'alreadySkipped': instance.alreadySkipped,
    };

_FollowWinnerView _$FollowWinnerViewFromJson(Map<String, dynamic> json) =>
    _FollowWinnerView(
      handle: json['handle'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String?,
      headline: json['headline'] as String?,
      linkedinUrl: json['linkedinUrl'] as String? ?? '',
      linkedinDone: json['linkedinDone'] as bool? ?? false,
      plexaverseDone: json['plexaverseDone'] as bool? ?? false,
      done: json['done'] as bool? ?? false,
      paid: (json['paid'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FollowWinnerViewToJson(_FollowWinnerView instance) =>
    <String, dynamic>{
      'handle': instance.handle,
      'name': instance.name,
      'image': instance.image,
      'headline': instance.headline,
      'linkedinUrl': instance.linkedinUrl,
      'linkedinDone': instance.linkedinDone,
      'plexaverseDone': instance.plexaverseDone,
      'done': instance.done,
      'paid': instance.paid,
    };

_FollowWinnersView _$FollowWinnersViewFromJson(Map<String, dynamic> json) =>
    _FollowWinnersView(
      status:
          $enumDecodeNullable(
            _$FollowWinnersStatusEnumMap,
            json['status'],
            unknownValue: FollowWinnersStatus.unavailable,
          ) ??
          FollowWinnersStatus.unavailable,
      reason: $enumDecodeNullable(
        _$FollowWinnersReasonEnumMap,
        json['reason'],
        unknownValue: JsonKey.nullForUndefinedEnumValue,
      ),
      pointsEach: (json['pointsEach'] as num?)?.toInt() ?? 0,
      fromRoundLastDayKey: json['fromRoundLastDayKey'] as String?,
      winners:
          (json['winners'] as List<dynamic>?)
              ?.map((e) => FollowWinnerView.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FollowWinnerView>[],
    );

Map<String, dynamic> _$FollowWinnersViewToJson(_FollowWinnersView instance) =>
    <String, dynamic>{
      'status': _$FollowWinnersStatusEnumMap[instance.status]!,
      'reason': _$FollowWinnersReasonEnumMap[instance.reason],
      'pointsEach': instance.pointsEach,
      'fromRoundLastDayKey': instance.fromRoundLastDayKey,
      'winners': instance.winners.map((e) => e.toJson()).toList(),
    };

const _$FollowWinnersStatusEnumMap = {
  FollowWinnersStatus.unavailable: 'unavailable',
  FollowWinnersStatus.open: 'open',
  FollowWinnersStatus.done: 'done',
};

const _$FollowWinnersReasonEnumMap = {
  FollowWinnersReason.notRunning: 'not_running',
  FollowWinnersReason.notJoined: 'not_joined',
  FollowWinnersReason.noWinners: 'no_winners',
};

_FollowWinnerStepResult _$FollowWinnerStepResultFromJson(
  Map<String, dynamic> json,
) => _FollowWinnerStepResult(
  view: FollowWinnersView.fromJson(json['view'] as Map<String, dynamic>),
  pointsApplied: (json['pointsApplied'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$FollowWinnerStepResultToJson(
  _FollowWinnerStepResult instance,
) => <String, dynamic>{
  'view': instance.view.toJson(),
  'pointsApplied': instance.pointsApplied,
};
