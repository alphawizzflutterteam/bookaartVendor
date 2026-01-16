import 'dart:convert';

class ServiceCategoryModel {
    final int? id;
    final String? name;
    final String? slug;
    final String? icon;
    final int? parentId;
    final int? position;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? homeStatus;
    final int? priority;
    final List<dynamic>? translations;

    ServiceCategoryModel({
        this.id,
        this.name,
        this.slug,
        this.icon,
        this.parentId,
        this.position,
        this.createdAt,
        this.updatedAt,
        this.homeStatus,
        this.priority,
        this.translations,
    });

    factory ServiceCategoryModel.fromRawJson(String str) => ServiceCategoryModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) => ServiceCategoryModel(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        icon: json["icon"],
        parentId: json["parent_id"],
        position: json["position"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        homeStatus: json["home_status"],
        priority: json["priority"],
        translations: json["translations"] == null ? [] : List<dynamic>.from(json["translations"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "icon": icon,
        "parent_id": parentId,
        "position": position,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "home_status": homeStatus,
        "priority": priority,
        "translations": translations == null ? [] : List<dynamic>.from(translations!.map((x) => x)),
    };
}
