import 'dart:async';
import 'dart:typed_data';

import '../../core/crypto/bytes.dart';
import '../../core/db/registry_db.dart';
import 'checkin_service.dart';

/// The voter details the check-in desk shows. Sent to a paired check-in
/// tablet only inside the encrypted channel.
class VoterView {
  const VoterView({
    required this.id,
    required this.voterNo,
    required this.fullName,
    required this.groupName,
    required this.checkedIn,
    this.photo,
  });

  final String id;
  final int voterNo;
  final String fullName;
  final String groupName;
  final bool checkedIn;
  final Uint8List? photo;

  factory VoterView.of(Voter v, bool checkedIn) => VoterView(
      id: v.id, voterNo: v.voterNo, fullName: v.fullName, groupName: v.groupName, checkedIn: checkedIn, photo: v.photo);

  VoterView withCheckedIn(bool c) =>
      VoterView(id: id, voterNo: voterNo, fullName: fullName, groupName: groupName, checkedIn: c, photo: photo);

  Map<String, Object?> toJson() => {
        'id': id,
        'n': voterNo,
        'name': fullName,
        'group': groupName,
        'in': checkedIn,
        'photo': photo == null ? null : b64(photo!),
      };

  factory VoterView.fromJson(Map m) => VoterView(
        id: m['id'] as String,
        voterNo: m['n'] as int,
        fullName: m['name'] as String,
        groupName: m['group'] as String,
        checkedIn: m['in'] as bool,
        photo: m['photo'] == null ? null : unb64(m['photo'] as String),
      );
}

class CardView {
  const CardView(this.result, [this.voter]);
  final CardResult result;
  final VoterView? voter;
}

typedef DeskCounts = ({int checkedIn, int registered});

/// What the check-in desk needs; local on the laptop, remote on a tablet.
abstract class CheckInBackend {
  Future<List<VoterView>> search(String query);
  Future<CardView> lookupCard(String qr);
  /// Returns the one-time code to give the voter.
  Future<String> checkIn(String voterId, {required String method});
  Future<String> manualCheckIn(int voterNo, {required ManualReason reason, String details});
  Stream<DeskCounts> counts();
}

/// The desk on the station laptop itself.
class LocalCheckInBackend implements CheckInBackend {
  LocalCheckInBackend(this.service, {required this.official});
  final CheckInService service;
  final String official;

  @override
  Future<List<VoterView>> search(String query) async =>
      [for (final s in await service.search(query)) VoterView.of(s.voter, s.checkedIn)];

  @override
  Future<CardView> lookupCard(String qr) async {
    final r = await service.lookupCard(qr);
    if (r.voter == null) return CardView(r.result);
    return CardView(r.result, VoterView.of(r.voter!, await service.isCheckedIn(r.voter!.id)));
  }

  @override
  Future<String> checkIn(String voterId, {required String method}) =>
      service.checkIn(voterId, method: method, official: official);

  @override
  Future<String> manualCheckIn(int voterNo, {required ManualReason reason, String details = ''}) =>
      service.manualCheckIn(voterNo, reason: reason, details: details, official: official);

  @override
  Stream<DeskCounts> counts() => service.watchCounts();
}
