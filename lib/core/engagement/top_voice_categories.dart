/// The forty subjects a curated LinkedIn post can belong to.
///
/// A port of the web's `lib/top-voice-categories.ts`, and a leaf module here
/// for the same reason it is one there.
///
/// ## Why a closed list, and why the ids are what travel
///
/// This is the only thing joining an imported post to a user. A post carries
/// one of these; a user carries the handful that match their work; the daily
/// picks are the intersection. If either side could invent a value the join
/// silently returns nothing — a user with "AI" never meets a post tagged
/// "Artificial Intelligence", and nobody finds out, because an empty feed
/// looks exactly like a quiet day.
///
/// The server enforces this: `UpdateUserPreferencesSchema` refines
/// `postCategories` against `isTopVoiceCategoryId` and the whole PATCH fails
/// on an unknown value. So the picker writes the KEYS of this map, never the
/// labels — two of this app's fake repositories seeded labels, and would have
/// had every preferences write rejected the moment a real backend saw them.
///
/// Labels are display only. Renaming one for the UI never touches a stored row.
library;

/// id -> display label, in the web's order, which is roughly by how many posts
/// carry each subject.
const Map<String, String> topVoiceCategories = <String, String>{
  'business_strategy': 'Business Strategy',
  'marketing': 'Marketing',
  'career': 'Career',
  'technology': 'Technology',
  'finance': 'Finance',
  'innovation': 'Innovation',
  'leadership': 'Leadership',
  'sales': 'Sales',
  'csr': 'Corporate Social Responsibility',
  'recruitment_hr': 'Recruitment & HR',
  'artificial_intelligence': 'Artificial Intelligence',
  'workplace_trends': 'Workplace Trends',
  'productivity': 'Productivity',
  'customer_experience': 'Customer Experience',
  'communication': 'Communication',
  'training_development': 'Training & Development',
  'engineering': 'Engineering',
  'organizational_culture': 'Organizational Culture',
  'science': 'Science',
  'supply_chain': 'Supply Chain Management',
  'hospitality_tourism': 'Hospitality & Tourism',
  'economics': 'Economics',
  'writing': 'Writing',
  'change_management': 'Change Management',
  'consulting': 'Consulting',
  'employee_experience': 'Employee Experience',
  'networking': 'Networking',
  'education': 'Education',
  'ecommerce': 'Ecommerce',
  'user_experience': 'User Experience',
  'design': 'Design',
  'soft_skills': 'Soft Skills & Emotional Intelligence',
  'real_estate': 'Real Estate',
  'retail_merchandising': 'Retail & Merchandising',
  'project_management': 'Project Management',
  'negotiation': 'Negotiation',
  'future_of_work': 'Future Of Work',
  'fundraising': 'Fundraising',
  'healthcare': 'Healthcare',
  'event_planning': 'Event Planning',
};

/// The label for an id, falling back to the id itself.
///
/// A category that is not on the list cannot come from our own import, but it
/// can come from a row written before the list was closed. Showing the raw id
/// is ugly and honest; inventing a label would hide the drift.
String topVoiceCategoryLabel(String id) => topVoiceCategories[id] ?? id;

/// Whether [id] is one of the forty. Mirrors `isTopVoiceCategoryId`.
bool isTopVoiceCategoryId(String id) => topVoiceCategories.containsKey(id);
