import 'package:intl/intl.dart';

/// The number and date formats every company surface shares.
///
/// Held apart from the widgets that use them so a screen can be removed
/// without taking a formatter three other screens depend on with it — which
/// matters here, because `/company-analytics` also exists as its own slice
/// (`features/analytics`). That slice has since been deleted — this is the
/// only copy.

/// JavaScript's `toLocaleString()` — the thousands separator every figure on
/// these screens carries.
final NumberFormat companyNumber = NumberFormat.decimalPattern();

/// `toLocaleDateString('en-US', {month: 'short', day: 'numeric'})`.
final DateFormat companyShortDate = DateFormat('MMM d');

/// A post's publication date in the inbox list.
final DateFormat companyFullDate = DateFormat('d MMM y');

/// A comment's arrival time.
///
/// The web concatenates `toLocaleDateString()` and `toLocaleTimeString()` with
/// NO separator, producing timestamps like `3/4/202609:41 AM`. That is a bug,
/// not a style, so it is not ported — the two parts are joined properly here.
final DateFormat companyTimestamp = DateFormat('d MMM y · HH:mm');
