#!/usr/bin/env python3
"""
Serializer that convert object
to JSON and vice versa.
"""
from django.contrib.auth import get_user_model
from rest_framework import serializers
from accounts.serializers import ProfileSerializer
from .models import (
    Campaign,
    Negotiation,
    Analytics,
    Review,
    Portfolio,
    Project
    )

User = get_user_model()


class CampaignSerializer(serializers.ModelSerializer):
    """
    A serializer for Campaign model.
    """
    class Meta:
        model = Campaign
        fields = '__all__'


class NegotiationSerializer(serializers.ModelSerializer):
    """
    A serializer for Negotiation model.
    """
    class Meta:
        model = Negotiation
        fields = '__all__'


class AnalyticsSerializer(serializers.ModelSerializer):
    """
    A serializer for Analytics model.
    """
    class Meta:
        model = Analytics
        fields = '__all__'


class ReviewSerializer(serializers.ModelSerializer):
    """
    A serializer for Review model.
    """
    class Meta:
        model = Review
        fields = '__all__'


class PortfolioSerializer(serializers.ModelSerializer):
    """
    A serializer for Portfolio model.
    """
    class Meta:
        model = Portfolio
        fields = '__all__'


class ProjectSerializer(serializers.ModelSerializer):
    """
    A serializer for Project model.
    """
    class Meta:
        model = Project
        fields = '__all__'


class InfluencerListSerializer(serializers.ModelSerializer):
    """
    A serializer for listing influencers,
    including both User and Profile information.
    """
    profile = ProfileSerializer(read_only=True)

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'niche', 'profile']


class SearchSerializer(serializers.Serializer):
    """
    Defines the structure for search and filter parameters,
    """
    query = serializers.CharField(required=False, allow_blank=True)
    niche = serializers.CharField(required=False, allow_blank=True)
    min_followers = serializers.IntegerField(required=False)
    max_followers = serializers.IntegerField(required=False)
    min_engagement = serializers.FloatField(required=False)
    max_engagement = serializers.FloatField(required=False)
    ordering = serializers.ChoiceField(
        choices=[
            'followers_count',
            '-followers_count',
            'engagement_rate',
            '-engagement_rate'],
        required=False
    )
