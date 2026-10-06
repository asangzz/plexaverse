import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/theme/zave/zave_colors.dart';
import 'package:plexaverse/features/planner/domain/plan_slot.dart';
import 'package:plexaverse/features/planner/domain/video_script.dart';
import 'package:plexaverse/features/planner/presentation/widgets/slot_card.dart';

void main() {
  group('VideoBeat', () {
    test('reads a timecode the way a person would', () {
      expect(const VideoBeat(seconds: 0).timecode, '0:00');
      expect(const VideoBeat(seconds: 8).timecode, '0:08');
      expect(const VideoBeat(seconds: 65).timecode, '1:05');
      expect(const VideoBeat(seconds: 600).timecode, '10:00');
    });
  });

  group('VideoScript', () {
    test('is posted only once the user has said so', () {
      // There is no other signal. LinkedIn's video upload is a different API
      // from a text share and this product does not speak it, so no share URN
      // ever comes back to match against.
      expect(const VideoScript().isPosted, isFalse);
      expect(const VideoScript(status: 'ready').isPosted, isFalse);
      expect(const VideoScript(status: 'published').isPosted, isTrue);
    });

    test('runtime comes off the last beat, and is zero without one', () {
      expect(const VideoScript().runtimeSeconds, 0);
      expect(
        const VideoScript(
          beats: <VideoBeat>[
            VideoBeat(seconds: 0),
            VideoBeat(seconds: 26),
          ],
        ).runtimeSeconds,
        26,
      );
    });

    test('parses the wire shape the mobile route sends', () {
      final VideoScript v = VideoScript.fromJson(<String, dynamic>{
        'id': 'vs-1',
        'weekNumber': 3,
        'season': 1,
        'dayIndex': 2,
        'title': 'A title',
        'hook': 'A hook',
        'caption': 'A caption',
        'status': 'ready',
        'publishedAt': null,
        'beats': <Map<String, dynamic>>[
          {'seconds': 0, 'say': 'Line one', 'show': 'Camera'},
          {'seconds': 7, 'say': 'Line two', 'show': 'Cut'},
        ],
      });

      expect(v.dayIndex, 2);
      expect(v.beats, hasLength(2));
      expect(v.beats.last.timecode, '0:07');
      expect(v.isPosted, isFalse);
    });

    test('survives beats arriving as something other than a list', () {
      // The column is Json on the server and the service only coerces what it
      // can; a malformed row must cost the card its shot list, not the screen.
      final VideoScript v = VideoScript.fromJson(<String, dynamic>{
        'id': 'vs-1',
        'hook': 'A hook',
        'beats': <dynamic>[],
      });
      expect(v.hasBeats, isFalse);
    });
  });

  group('slotSignal on a hand-off day', () {
    const PlanSlot video = PlanSlot(day: 'Wednesday', rawKind: 'video_script');
    const PlanSlot article = PlanSlot(day: 'Thursday', rawKind: 'article');

    test('stays quiet until the answer arrives', () {
      // Guessing "to write" and correcting a beat later is worse than saying
      // nothing: the user reads the first label and acts on it.
      expect(slotSignal(video).label, 'Video');
      expect(slotSignal(article).label, 'Newsletter');
      expect(slotSignal(video).color, ZaveColors.ink35);
    });

    test('is amber when it is waiting on the user', () {
      // Zave reserves amber for "waiting on YOU", and a written hand-off is
      // the only state on this screen that needs the user to go and do
      // something.
      expect(
        slotSignal(video, handoff: HandoffState.ready).color,
        ZaveColors.amber,
      );
      expect(
        slotSignal(article, handoff: HandoffState.ready).label,
        'Ready to post',
      );
      expect(
        slotSignal(video, handoff: HandoffState.ready).label,
        'Ready to film',
      );
    });

    test('is green once it is done', () {
      expect(
        slotSignal(video, handoff: HandoffState.posted).color,
        ZaveColors.green,
      );
      expect(
        slotSignal(article, handoff: HandoffState.posted).label,
        'Posted',
      );
    });

    test('never reads slot.status on a hand-off day', () {
      // The bug this whole slice exists for. `status` is written only by the
      // post-generation path, which a hand-off day never reaches — so it read
      // `planned` for ever and Wednesday said "Script to write" over a script
      // that had been written, filmed and posted.
      for (final SlotStatus status in SlotStatus.values) {
        expect(
          slotSignal(
            video.copyWith(status: status),
            handoff: HandoffState.posted,
          ).label,
          'Posted',
          reason: 'status $status must not change a hand-off day',
        );
      }
    });

    test('a post day is unaffected and still reads its status', () {
      const PlanSlot post = PlanSlot(day: 'Monday', rawKind: 'post');
      expect(
        slotSignal(post.copyWith(status: SlotStatus.published)).label,
        'Published',
      );
      expect(
        slotSignal(post.copyWith(status: SlotStatus.generated)).label,
        'Needs approval',
      );
      // And a hand-off answer handed to a post day is simply ignored.
      expect(
        slotSignal(
          post.copyWith(status: SlotStatus.published),
          handoff: HandoffState.notWritten,
        ).label,
        'Published',
      );
    });

    test('a rest day says so regardless', () {
      const PlanSlot rest = PlanSlot(day: 'Saturday', rawKind: 'rest');
      expect(slotSignal(rest).label, 'Rest day');
      expect(
        slotSignal(rest, handoff: HandoffState.ready).label,
        'Rest day',
      );
    });
  });
}
