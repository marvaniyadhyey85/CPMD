import 'package:flutter/material.dart';

const override = Object();

class NewsArticle {
  final String id;
  final String title;
  final String description;
  final String category;
  final String author;
  final String authorAvatar;
  final String imageUrl;
  final String timeAgo;
  final String readTime;
  final bool isFeatured;
  final bool isTrending;
  bool isBookmarked;

  NewsArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.author,
    required this.authorAvatar,
    required this.imageUrl,
    required this.timeAgo,
    required this.readTime,
    this.isFeatured = false,
    this.isTrending = false,
    this.isBookmarked = false,
  });
}

class NewsCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final int articleCount;
  final String imageUrl;

  NewsCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.articleCount,
    required this.imageUrl,
  });
}

class VideoItem {
  final String id;
  final String title;
  final String channelName;
  final String channelAvatar;
  final String duration;
  final String views;
  final String timeAgo;
  final String thumbnailUrl;
  final String category;
  final bool isFeatured;

  VideoItem({
    required this.id,
    required this.title,
    required this.channelName,
    required this.channelAvatar,
    required this.duration,
    required this.views,
    required this.timeAgo,
    required this.thumbnailUrl,
    required this.category,
    this.isFeatured = false,
  });
}

class UserProfile {
  final String name;
  final String handle;
  final String bio;
  final String avatarUrl;
  final String coverUrl;
  final int followersCount;
  final int followingCount;
  final int articlesPublished;
  final int likesCount;

  UserProfile({
    required this.name,
    required this.handle,
    required this.bio,
    required this.avatarUrl,
    required this.coverUrl,
    required this.followersCount,
    required this.followingCount,
    required this.articlesPublished,
    required this.likesCount,
  });
}
