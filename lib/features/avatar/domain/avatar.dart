class Avatar {
 final String id;
 final String name;
 final int age;
 final String quote;
 final String description;
 final List<String> personalityTraits;
 final String communicationStyle;
 final Map<String, String> expressions;

 const Avatar({
 required this.id,
 required this.name,
 this.age = 14,
 this.quote = '',
 required this.description,
 this.personalityTraits = const [],
 this.communicationStyle = 'warm',
 required this.expressions,
 });

 factory Avatar.fromJson(Map<String, dynamic> json) {
 return Avatar(
 id: json['id'] as String,
 name: json['name'] as String,
 age: (json['age'] as int?) ?? 14,
 quote: (json['quote'] as String?) ?? '',
 description: json['description'] as String,
 personalityTraits: (json['personalityTraits'] as List?)?.map((e) => e.toString()).toList() ?? [],
 communicationStyle: (json['communicationStyle'] as String?) ?? 'warm',
 expressions: Map<String, String>.from(json['expressions'] as Map? ?? {}),
 );
 }

 Map<String, dynamic> toJson() {
 return {
 'id': id,
 'name': name,
 'age': age,
 'quote': quote,
 'description': description,
 'personalityTraits': personalityTraits,
 'communicationStyle': communicationStyle,
 'expressions': expressions,
 };
 }
}

