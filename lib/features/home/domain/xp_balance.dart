import 'package:freezed_annotation/freezed_annotation.dart';

part 'xp_balance.freezed.dart';
part 'xp_balance.g.dart';

/// The user's XP balance, from `GET /user/xp`.
///
/// The endpoint also returns the last twenty transactions and the whole XP
/// config map. Neither is on the home screen — the web renders only the
/// compact balance chip up in the mobile header — so only `balance` is
/// modelled here. json_serializable drops the rest, which keeps this screen
/// from quietly acquiring a dependency on a payload it does not draw.
@freezed
abstract class XpBalance with _$XpBalance {
  const XpBalance._();

  const factory XpBalance({@Default(0) int balance}) = _XpBalance;

  factory XpBalance.fromJson(Map<String, dynamic> json) =>
      _$XpBalanceFromJson(json);
}
