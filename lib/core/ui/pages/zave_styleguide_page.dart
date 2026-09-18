import 'package:flutter/material.dart';

import '../zave/zave_kit.dart';

/// The Zave design-system reference — the Flutter counterpart of the web's
/// `/zave-style-guide`.
///
/// Open the two side by side to check fidelity. Everything on this page is
/// rendered from the tokens in `core/theme/zave/`, so if a specimen here looks
/// wrong the token is wrong, not the screen.
class ZaveStyleguidePage extends StatefulWidget {
  const ZaveStyleguidePage({super.key});

  @override
  State<ZaveStyleguidePage> createState() => _ZaveStyleguidePageState();
}

class _ZaveStyleguidePageState extends State<ZaveStyleguidePage> {
  int _chip = 0;
  bool _switchOn = true;
  final TextEditingController _field = TextEditingController();

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ZaveScaffold(
      title: 'Zave',
      leading: ZaveIconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).maybePop(),
        tooltip: 'Back',
      ),
      body: ZaveScrollView(
        children: <Widget>[
          Text('Design\nsystem', style: ZaveType.hero),
          SizedBox(height: ZaveSpace.lg),
          Text(
            'Every specimen below is rendered from core/theme/zave. It should '
            'match the web app at /zave-style-guide.',
            style: ZaveType.lead,
          ),

          _section('01', 'Ground'),
          _swatches(const <(String, Color)>[
            ('void', ZaveColors.void_),
            ('midnight', ZaveColors.midnight),
            ('deep', ZaveColors.deep),
            ('glow', ZaveColors.glow),
            ('horizon', ZaveColors.horizon),
          ]),

          _section('02', 'Signal'),
          Text(
            'Colour only ever names a status.',
            style: ZaveType.bodyMuted,
          ),
          SizedBox(height: ZaveSpace.lg),
          _swatches(const <(String, Color)>[
            ('green · done', ZaveColors.green),
            ('mint', ZaveColors.mint),
            ('amber · waiting', ZaveColors.amber),
            ('blue · XP', ZaveColors.blue),
            ('peri · links', ZaveColors.peri),
            ('sched · queued', ZaveColors.scheduled),
            ('ink · on white', ZaveColors.ink),
          ]),

          _section('03', 'Ink'),
          _swatches(const <(String, Color)>[
            ('85', ZaveColors.ink85),
            ('62', ZaveColors.ink62),
            ('50', ZaveColors.ink50),
            ('45', ZaveColors.ink45),
            ('35', ZaveColors.ink35),
            ('rule', ZaveColors.rule),
          ]),

          _section('04', 'Glass'),
          Text(
            'Depth is the fill step, never a shadow.',
            style: ZaveType.bodyMuted,
          ),
          SizedBox(height: ZaveSpace.lg),
          Row(
            children: <Widget>[
              Expanded(child: _glassBox('rest', ZaveSurface.card)),
              SizedBox(width: ZaveSpace.md),
              Expanded(child: _glassBox('hover', ZaveSurface.listRowPressed)),
              SizedBox(width: ZaveSpace.md),
              Expanded(child: _glassBox('now', ZaveSurface.rowNow)),
            ],
          ),

          _section('05', 'Type'),
          _type('hero 52/800', ZaveType.hero, 'Build in public'),
          _type('h2 34/800', ZaveType.h2, 'This week'),
          _type('h3 20/800', ZaveType.h3, 'Section title'),
          _type('kicker 13/700', ZaveType.kicker, 'OVERVIEW'),
          _type('num 13/700', ZaveType.num, '04'),
          _type('lead 18', ZaveType.lead, 'The paragraph under a heading.'),
          _type('body 17', ZaveType.body, 'Ordinary reading copy.'),
          _type('label 15/600', ZaveType.label, 'Chip label'),
          _type('caption 13', ZaveType.caption, 'Metadata · 2h ago'),
          _type('mono 13', ZaveType.mono, 'post_id = 41f2'),

          _section('06', 'Buttons'),
          Text(
            'Solid white is the one primary action on a screen. Blue is only '
            'the XP / upgrade path. Everything is a full pill.',
            style: ZaveType.bodyMuted,
          ),
          SizedBox(height: ZaveSpace.lg),
          Wrap(
            spacing: ZaveSpace.md,
            runSpacing: ZaveSpace.md,
            children: <Widget>[
              ZaveButton.primary(label: 'Publish', onPressed: () {}),
              ZaveButton(
                label: 'Publish',
                kind: ZaveButtonKind.primarySmall,
                onPressed: () {},
              ),
              ZaveButton(label: 'Cancel', onPressed: () {}),
              ZaveButton.brand(label: 'Get XP', onPressed: () {}),
              ZaveButton(label: 'Disabled', onPressed: null),
              ZaveButton(label: 'Saving', busy: true, onPressed: () {}),
              ZaveIconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: ZaveSpace.lg),
          ZaveButton.primary(
            label: 'Full width',
            expand: true,
            icon: const Icon(Icons.auto_awesome),
            onPressed: () {},
          ),

          _section('07', 'Chips & pills'),
          Text(
            'Selected inverts to white. Never a tint, never an underline.',
            style: ZaveType.bodyMuted,
          ),
          SizedBox(height: ZaveSpace.lg),
          Wrap(
            spacing: ZaveSpace.sm,
            runSpacing: ZaveSpace.sm,
            children: <Widget>[
              for (int i = 0; i < 3; i++)
                ZaveChip(
                  label: <String>['All', 'Drafts', 'Scheduled'][i],
                  selected: _chip == i,
                  onTap: () => setState(() => _chip = i),
                ),
            ],
          ),
          SizedBox(height: ZaveSpace.md),
          Wrap(
            spacing: ZaveSpace.sm,
            runSpacing: ZaveSpace.sm,
            children: const <Widget>[
              ZavePill(
                label: 'Published',
                color: ZaveColors.green,
                leading: ZaveDot(ZaveColors.green),
              ),
              ZavePill(
                label: 'Scheduled',
                color: ZaveColors.scheduled,
                leading: ZaveDot(ZaveColors.scheduled),
              ),
              ZavePill(
                label: 'Needs review',
                color: ZaveColors.amber,
                leading: ZaveDot(ZaveColors.amber),
              ),
            ],
          ),

          _section('08', 'Cards & rows'),
          ZaveCard(
            size: ZaveCardSize.large,
            child: Text('cardLg · r28', style: ZaveType.h3),
          ),
          SizedBox(height: ZaveSpace.md),
          ZaveCard(child: Text('card · r24', style: ZaveType.h3)),
          SizedBox(height: ZaveSpace.md),
          ZaveCard(
            size: ZaveCardSize.compact,
            onTap: () {},
            child: Text('tappable · r20', style: ZaveType.h3),
          ),
          SizedBox(height: ZaveSpace.md),
          ZaveCard(
            size: ZaveCardSize.small,
            isNow: true,
            child: Text('isNow · today', style: ZaveType.h3),
          ),

          _section('09', 'Fields'),
          ZaveField(
            controller: _field,
            label: 'Topic',
            hint: 'What is this week about?',
            helper: 'Focus brightens the border — no focus ring.',
          ),
          SizedBox(height: ZaveSpace.lg),
          const ZaveField(
            hint: 'Search posts',
            pill: true,
            prefix: Icon(Icons.search),
          ),
          SizedBox(height: ZaveSpace.lg),
          const ZaveField(
            label: 'Headline',
            hint: 'Required',
            error: 'Amber, not red — red is not in this palette.',
          ),

          _section('10', 'Switch'),
          Row(
            children: <Widget>[
              ZaveSwitch(
                value: _switchOn,
                onChanged: (bool v) => setState(() => _switchOn = v),
                semanticLabel: 'Auto-post',
              ),
              SizedBox(width: ZaveSpace.lg),
              Text('Auto-post', style: ZaveType.body),
            ],
          ),
        ],
      ),
    );
  }

  Widget _section(String number, String title) => Padding(
    padding: EdgeInsets.only(top: ZaveSpace.section, bottom: ZaveSpace.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(height: 1, color: ZaveColors.rule),
        SizedBox(height: ZaveSpace.xl),
        Row(
          children: <Widget>[
            Text(number, style: ZaveType.num),
            SizedBox(width: ZaveSpace.md),
            Text(title.toUpperCase(), style: ZaveType.kicker),
          ],
        ),
        SizedBox(height: ZaveSpace.md),
      ],
    ),
  );

  Widget _swatches(List<(String, Color)> items) => Wrap(
    spacing: ZaveSpace.md,
    runSpacing: ZaveSpace.md,
    children: <Widget>[
      for (final (String name, Color c) in items)
        SizedBox(
          width: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: ZaveRadius.cardSmBr,
                  border: Border.all(color: ZaveColors.rule, width: 1),
                ),
              ),
              SizedBox(height: ZaveSpace.sm),
              Text(name, style: ZaveType.caption),
            ],
          ),
        ),
    ],
  );

  Widget _glassBox(String label, BoxDecoration deco) => Container(
    height: 84,
    decoration: deco,
    alignment: Alignment.center,
    child: Text(label, style: ZaveType.label),
  );

  Widget _type(String name, TextStyle style, String sample) => Padding(
    padding: EdgeInsets.only(bottom: ZaveSpace.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(name, style: ZaveType.caption),
        SizedBox(height: ZaveSpace.xs),
        Text(sample, style: style),
      ],
    ),
  );
}
